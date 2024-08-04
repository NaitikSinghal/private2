import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/widgets/analytics/spline_chart.dart';
import 'package:pherico/widgets/analytics/views_chart.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class Analytics extends StatelessWidget {
  const Analytics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: CustomAppbar(
          title: 'Analytics',
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        analyticCard(CupertinoIcons.cube_box, 'Orders', 42),
                        analyticCard(Icons.sell_outlined, 'Sale', '4.2k'),
                        analyticCard(
                            Icons.remove_red_eye_outlined, 'Views', 42),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const SplineChart(),
              const SizedBox(
                height: 8,
              ),
              const ViewsChart(),
            ],
          ),
        ),
      )),
    );
  }

  Widget analyticCard(icon, title, number) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: HexColor('#EBEBEB'),
              child: Icon(
                icon,
                color: HexColor('#4318FF'),
                size: 26,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: greyText),
                ),
                Text(
                  number.toString(),
                  style: TextStyle(
                      color: textColor_1,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
