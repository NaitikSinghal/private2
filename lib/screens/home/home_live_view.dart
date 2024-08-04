import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/screens/live/audience.dart';
import 'package:pherico/utils/border.dart';
import 'package:pherico/widgets/skeletons/container_skeleton.dart';

class HomeLiveView extends StatelessWidget {
  final String thumbnail;
  final int liveCount;
  final String liveId;
  final List productIds;
  const HomeLiveView(
      {super.key,
      required this.thumbnail,
      required this.liveCount,
      required this.liveId,
      required this.productIds});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(right: 14.0),
      child: InkWell(
        onTap: () {
          Get.to(
              () => Audience(
                    liveId: liveId,
                    productIds: productIds,
                  ),
              transition: Transition.leftToRight);
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: thumbnail,
                height: deviceSize.height * 0.25,
                width: deviceSize.width * 0.42,
                fit: BoxFit.cover,
                placeholder: (context, progress) {
                  return const ContainerSkeleton();
                },
              ),
            ),
            Positioned(
              top: 4,
              left: 4,
              child: Card(
                shape: borderShape(radius: 20),
                color: const Color.fromARGB(230, 22, 44, 33),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    onPressed: () {},
                    icon: Container(
                      height: 24,
                      width: 24,
                      padding: const EdgeInsets.only(left: 2, top: 2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 192, 35, 23),
                      ),
                      child: const Icon(
                        CupertinoIcons.play_arrow,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                    label: Text(
                      liveCount.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
