import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/clicky.dart';
import 'package:pherico/resources/saved_items_resource.dart';
import 'package:pherico/screens/clicky/single_clicky_player.dart';
import 'package:pherico/utils/toast_extension.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SavedClickies extends StatelessWidget {
  const SavedClickies({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: firebaseFirestore
          .collection(savedClickyCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyProgressIndicator();
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error occured'),
          );
        }
        if (snapshot.hasData && snapshot.data!.data()!['clickies'].isEmpty) {
          return const Center(
            child: Text('No clicky found'),
          );
        }

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firebaseFirestore
              .collection(clickiesCollection)
              .where('id', whereIn: snapshot.data!.data()!['clickies'])
              .snapshots(),
          builder: (context, snapshot2) {
            if (snapshot2.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot2.hasError) {
              return const Center(
                child: Text('An error occured'),
              );
            }
            if (snapshot2.hasData) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: GridView.builder(
                  itemCount: snapshot.data!.data()!['clickies'].length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    Clicky clicky =
                        Clicky.fromSnap(snapshot2.data!.docs[index]);
                    return InkWell(
                      onTap: () {
                        Get.to(() => SingleClickyPlayer(clicky: clicky),
                            transition: Transition.downToUp);
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: clicky.thumbnail,
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return SkeletonAnimation(
                                  shimmerColor:
                                      const Color.fromARGB(255, 207, 207, 207),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 230, 230, 230),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: -4),
                              onPressed: () async {
                                try {
                                  await SavedItemsResource()
                                      .removeSavedClicky(clicky.id);
                                } catch (error) {
                                  context.showToast(
                                    isError: true,
                                    "Failed to remove",
                                  );
                                }
                              },
                              icon: const Icon(
                                CupertinoIcons.clear_circled_solid,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: Text('No item here'),
              );
            }
          },
        );
      },
    );
  }
}
