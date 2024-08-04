import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class ProductSkeleton extends StatelessWidget {
  const ProductSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  width: MediaQuery.of(context).size.width / 2 - 40,
                  height: MediaQuery.of(context).size.height * .15,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 235, 235, 235),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SkeletonAnimation(
                    borderRadius: BorderRadius.circular(5.0),
                    shimmerColor: index % 2 != 0
                        ? const Color.fromARGB(255, 207, 207, 207)
                        : Colors.white54,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color.fromARGB(255, 230, 230, 230)),
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  height: 15,
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 235, 235, 235),
                  ),
                  child: SkeletonAnimation(
                    shimmerColor: index % 2 != 0
                        ? const Color.fromARGB(255, 207, 207, 207)
                        : Colors.white54,
                    child: Container(
                      width: 80,
                      height: 15,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 230, 230, 230)),
                    ),
                  ),
                ),
                Container(
                  width: 110,
                  height: 15,
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 235, 235, 235),
                  ),
                  child: SkeletonAnimation(
                    shimmerColor: index % 2 != 0
                        ? const Color.fromARGB(255, 207, 207, 207)
                        : Colors.white54,
                    child: Container(
                      width: 110,
                      height: 15,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 230, 230, 230)),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  width: MediaQuery.of(context).size.width / 2 - 40,
                  height: MediaQuery.of(context).size.height * .15,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 235, 235, 235),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SkeletonAnimation(
                    borderRadius: BorderRadius.circular(5.0),
                    shimmerColor: index % 2 != 0
                        ? const Color.fromARGB(255, 207, 207, 207)
                        : Colors.white54,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color.fromARGB(255, 230, 230, 230)),
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  height: 15,
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 235, 235, 235),
                  ),
                  child: SkeletonAnimation(
                    shimmerColor: index % 2 != 0
                        ? const Color.fromARGB(255, 207, 207, 207)
                        : Colors.white54,
                    child: Container(
                      width: 80,
                      height: 15,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 230, 230, 230)),
                    ),
                  ),
                ),
                Container(
                  width: 110,
                  height: 15,
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 235, 235, 235),
                  ),
                  child: SkeletonAnimation(
                    shimmerColor: index % 2 != 0
                        ? const Color.fromARGB(255, 207, 207, 207)
                        : Colors.white54,
                    child: Container(
                      width: 110,
                      height: 15,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 230, 230, 230)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
