import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class AddressSkeleton extends StatelessWidget {
  const AddressSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 120,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 235, 235, 235),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                bottom: 5.0,
                              ),
                              child: SkeletonAnimation(
                                borderRadius: BorderRadius.circular(5.0),
                                shimmerColor: index % 2 != 0
                                    ? const Color.fromARGB(255, 207, 207, 207)
                                    : Colors.white54,
                                child: Container(
                                  height: 20,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: const Color.fromARGB(
                                          255, 230, 230, 230)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, bottom: 5.0, right: 8),
                              child: SkeletonAnimation(
                                borderRadius: BorderRadius.circular(5.0),
                                shimmerColor: index % 2 != 0
                                    ? const Color.fromARGB(255, 207, 207, 207)
                                    : Colors.white54,
                                child: Container(
                                  height: 20,
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: const Color.fromARGB(
                                          255, 230, 230, 230)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 6),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: SkeletonAnimation(
                              borderRadius: BorderRadius.circular(5.0),
                              shimmerColor: index % 2 != 0
                                  ? const Color.fromARGB(255, 207, 207, 207)
                                  : Colors.white54,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: const Color.fromARGB(
                                        255, 230, 230, 230)),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 4),
                              child: SkeletonAnimation(
                                borderRadius: BorderRadius.circular(5.0),
                                shimmerColor: index % 2 != 0
                                    ? const Color.fromARGB(255, 207, 207, 207)
                                    : Colors.white54,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: const Color.fromARGB(
                                          255, 230, 230, 230)),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, top: 10),
                              child: SkeletonAnimation(
                                borderRadius: BorderRadius.circular(5.0),
                                shimmerColor: index % 2 != 0
                                    ? const Color.fromARGB(255, 207, 207, 207)
                                    : Colors.white54,
                                child: Container(
                                  width: 60,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: const Color.fromARGB(
                                          255, 230, 230, 230)),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
