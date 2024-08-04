import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/clicky.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:pherico/screens/clicky/clicky_player_item.dart';

class Clickies extends StatefulWidget {
  const Clickies({super.key});

  @override
  State<Clickies> createState() => _ClickiesState();
}

class _ClickiesState extends State<Clickies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firebaseFirestore.collection(clickiesCollection).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MyProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          return PageView.builder(
            itemCount: snapshot.data!.docs.length,
            controller: PageController(initialPage: 0, viewportFraction: 1),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, i) {
              Clicky clicky = Clicky.fromSnap(snapshot.data!.docs[i]);
              return ClickyPlayerItem(
                clicky: clicky,
              );
            },
          );
        },
      ),
    );
  }
}
