import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/address.dart';
import 'package:pherico/screens/add_address.dart';
import 'package:pherico/widgets/address/address_list.dart';
import 'package:pherico/widgets/buttons/gradient_elevated_button.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:pherico/widgets/global/error_widget.dart';
import 'package:pherico/widgets/skeletons/address_skeleton.dart';

class MyAddress extends StatefulWidget {
  static const routerName = '/addresses';
  const MyAddress({super.key});

  @override
  State<MyAddress> createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // late Future _addressFuture;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppbar(
          onPressed: () {
            Navigator.of(context).pop();
          },
          title: 'My Addresses',
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firebaseFirestore
              .collection('addresses')
              .where('uid', isEqualTo: firebaseAuth.currentUser!.uid)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AddressSkeleton();
            } else {
              if (snapshot.error != null) {
                return const SomethingWentWrongError();
              } else {
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return Column(
                    children: [
                      const Expanded(
                        child: Center(
                          child: Text('No address'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                        child: GradientElevatedButton(
                          buttonName: 'Add Address',
                          onPressed: () {
                            Get.to(() => const AddAddress(),
                                transition: Transition.rightToLeft);
                          },
                          height: 44,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          key: const Key('address_list'),
                          itemCount: docs.length,
                          itemBuilder: (ctx, i) {
                            Address address = Address.fromSnap(docs[i]);

                            return AddressList(address: address);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                        child: GradientElevatedButton(
                          buttonName: 'Add Address',
                          onPressed: () {
                            Get.to(() => const AddAddress(),
                                transition: Transition.rightToLeft);
                          },
                          height: 44,
                        ),
                      ),
                    ],
                  );
                }
              }
            }
          },
        ),
      ),
    );
  }
}
