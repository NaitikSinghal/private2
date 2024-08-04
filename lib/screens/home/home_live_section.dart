import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/models/live_model.dart';
import 'package:pherico/screens/home/home_live_view.dart';
import 'package:pherico/screens/home/live_view_label.dart';
import 'package:pherico/widgets/skeletons/live_slider_skeleton.dart';

class HomeLiveSection extends StatelessWidget {
  const HomeLiveSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: firebaseFirestore
          .collection(liveCollection)
          .where('isLive', isEqualTo: true)
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LiveSliderSkeleton();
        } else if (snapshot.hasError) {
          return const SizedBox(
            height: 40,
            child: Center(
              child: Text('Something went wrong'),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return Column(
            children: [
              const SizedBox(
                height: 6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'For you',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: brownText),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.chevron_forward,
                        color: brownText,
                        size: 18,
                      ),
                      label: Text(
                        'Show All',
                        style: TextStyle(color: brownText, fontSize: 13),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.50,
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    LiveModel liveData =
                        LiveModel.fromJson(snapshot.data!.docs[index]);
                    return Column(
                      children: [
                        HomeLiveView(
                          thumbnail: liveData.thumbnail,
                          liveCount: liveData.members.length,
                          liveId: liveData.liveId,
                          productIds: liveData.products,
                        ),
                        LiveViewLabel(
                          hostName: liveData.hostName,
                          hostProfile: liveData.hostProfile,
                          liveTitle: liveData.liveTitle,
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return const SizedBox(
            height: 40,
            child: Center(
              child: Text('Currently no live'),
            ),
          );
        }
      },
    );
  }
}
