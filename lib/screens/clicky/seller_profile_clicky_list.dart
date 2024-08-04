import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/clicky.dart';
import 'package:pherico/screens/clicky/single_clicky_player.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:pherico/widgets/global/rounded_image.dart';

class SellerProfileClickyList extends StatelessWidget {
  final String uid;
  const SellerProfileClickyList({required this.uid, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FirestoreQueryBuilder<Map<String, dynamic>>(
        pageSize: 15,
        query: firebaseFirestore
            .collection(clickiesCollection)
            .where('userId', isEqualTo: uid)
            .orderBy('createdAt'),
        builder: (context, snapshot, _) {
          if (snapshot.isFetching) {
            return const MyProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          }

          return GridView.builder(
            itemCount: snapshot.docs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 2,
                mainAxisSpacing: 4),
            itemBuilder: (context, index) {
              if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                snapshot.fetchMore();
              }

              Clicky clicky = Clicky.fromMap(snapshot.docs[index].data());
              return InkWell(
                onTap: () {
                  Get.to(() => SingleClickyPlayer(clicky: clicky),
                      transition: Transition.downToUp);
                },
                child: Stack(
                  children: [
                    RoundedImage(
                      image: clicky.thumbnail,
                      isNetwork: true,
                    ),
                    Positioned(
                      right: 8,
                      bottom: 4,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            CupertinoIcons.play_fill,
                            color: Colors.white,
                          ),
                          Text(
                            '${clicky.playCount}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
