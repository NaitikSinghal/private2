import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class LiveSliderSkeleton extends StatelessWidget {
  const LiveSliderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SizedBox(
      height: deviceSize.height * 0.50,
      child: ListView.builder(
          itemCount: 5,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: deviceSize.height * 0.25,
                    width: deviceSize.width * 0.42,
                    decoration: BoxDecoration(
                      color: HexColor('#F4F4F4'),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: SkeletonAnimation(
                      borderRadius: BorderRadius.circular(8.0),
                      shimmerColor: Colors.white54,
                      child: Container(
                        height: deviceSize.height * 0.25,
                        width: deviceSize.width * 0.42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: const Color.fromARGB(255, 230, 230, 230),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: HexColor('#F4F4F4'),
                          shape: BoxShape.circle,
                        ),
                        child: SkeletonAnimation(
                          borderRadius: BorderRadius.circular(8.0),
                          shimmerColor: Colors.white54,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 230, 230, 230),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Container(
                        height: 20,
                        width: deviceSize.width * 0.325,
                        decoration: BoxDecoration(
                          color: HexColor('#F4F4F4'),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: SkeletonAnimation(
                          borderRadius: BorderRadius.circular(4.0),
                          shimmerColor: Colors.white54,
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(4.0),
                              color: const Color.fromARGB(255, 230, 230, 230),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    height: 20,
                    width: deviceSize.width * 0.42,
                    decoration: BoxDecoration(
                      color: HexColor('#F4F4F4'),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: SkeletonAnimation(
                      borderRadius: BorderRadius.circular(4.0),
                      shimmerColor: Colors.white54,
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(4.0),
                          color: const Color.fromARGB(255, 230, 230, 230),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
