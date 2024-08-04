import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/clicky.dart';
import 'package:pherico/screens/seller/add_clickies.dart';
import 'package:pherico/widgets/buttons/gradient_elevated_button.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';

class SellerClickies extends StatelessWidget {
  static const routeName = '/my-clickies';
  const SellerClickies({super.key});

  _pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    Get.back();
    if (video != null) {
      Get.to(
          () => AddClickies(
                videoPath: video.path,
                file: File(video.path),
              ),
          transition: Transition.leftToRight);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: CustomAppbar(
          title: 'Clickies',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FirestoreQueryBuilder<Map<String, dynamic>>(
                pageSize: 10,
                query: firebaseFirestore
                    .collection(clickiesCollection)
                    .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
                    .orderBy('createdAt'),
                builder: (context, snapshot, _) {
                  if (snapshot.isFetching) {
                    return const MyProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return const Text('Something went wrong!');
                  }
                  if (snapshot.hasData && snapshot.docs.isEmpty) {
                    return const Text('No Clickies Found');
                  }

                  return GridView.builder(
                    itemCount: snapshot.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemBuilder: (context, index) {
                      if (snapshot.hasMore &&
                          index + 1 == snapshot.docs.length) {
                        snapshot.fetchMore();
                      }

                      Clicky clickies =
                          Clicky.fromMap(snapshot.docs[index].data());

                      return Stack(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                            width: MediaQuery.of(context).size.width / 3,
                            child: CachedNetworkImage(
                              imageUrl: clickies.thumbnail,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.play_fill,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                Text(
                                  clickies.playCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: GradientElevatedButton(
                buttonName: 'Add',
                height: 46,
                onPressed: () {
                  _showBottomSheet(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(bottom: 10, top: 4),
          height: 140,
          child: Column(
            children: [
              Container(
                height: 8,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Create/Select clickies',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      _pickVideo(ImageSource.gallery, context);
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          size: 34,
                        ),
                        Text('Gallery'),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _pickVideo(ImageSource.camera, context);
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera,
                          size: 36,
                        ),
                        Text('Camera'),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cancel,
                          size: 36,
                        ),
                        Text('Cancel'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
