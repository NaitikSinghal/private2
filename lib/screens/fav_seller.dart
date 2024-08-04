import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/seller/seller.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:pherico/widgets/savedItems/fav_seller_list.dart';

class FavSeller extends StatefulWidget {
  const FavSeller({super.key});

  @override
  State<FavSeller> createState() => _FavSellerState();
}

class _FavSellerState extends State<FavSeller> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _stream;
  @override
  void initState() {
    super.initState();
    _stream = firebaseFirestore
        .collection(favSellerCollection)
        .doc(firebaseAuth.currentUser!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: CustomAppbar(
          title: 'Favrioute Sellers',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MyProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.data!.data()!.isEmpty) {
            return const Center(
              child: Text('No Fav Seller Found'),
            );
          }
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: firebaseFirestore
                .collection(storeCollection)
                .where('uid', whereIn: snapshot.data!.data()!['sellers'])
                .snapshots(),
            builder: (context, snapshot2) {
              if (snapshot2.connectionState == ConnectionState.waiting) {
                return const MyProgressIndicator();
              }
              if (snapshot2.hasError) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }
              if (snapshot2.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No Fav Seller Found'),
                );
              }
              return ListView.builder(
                key: const Key('address_list'),
                itemCount: snapshot2.data!.docs.length,
                itemBuilder: (ctx, i) {
                  Seller seller = Seller.fromJson(snapshot2.data!.docs[i]);
                  return FavSellerList(seller: seller);
                },
              );
            },
          );
        },
      )),
    );
  }
}
