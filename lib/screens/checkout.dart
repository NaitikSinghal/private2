import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/address.dart';
import 'package:pherico/screens/add_address.dart';
import 'package:pherico/screens/cart_screen.dart';
import 'package:pherico/widgets/buttons/gradient_elevated_button.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  late Address address;
  Future<void> _addressList(BuildContext ctx) async {
    await showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
          children: <Widget>[
            addressListWidget(ctx),
          ],
        );
      },
    );
  }

  setAddress(Address add) {
    setState(() {
      address = add;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppbar(
          onPressed: () {
            Get.to(() => const CartScreen(),
                transition: Transition.leftToRight);
          },
          title: 'Checkout',
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: firebaseFirestore
              .collection(addressesCollection)
              .where('uid', isEqualTo: firebaseAuth.currentUser!.uid)
              .where('isDefault', isEqualTo: 1)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MyProgressIndicator();
            } else {
              if (snapshot.hasData) {
                bool isAddress = snapshot.data!.docs.isNotEmpty;
                address = Address.fromSnap(snapshot.data!.docs[0]);
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        margin: const EdgeInsets.all(12),
                        elevation: 0,
                        color: cardBg,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 22.0, horizontal: 16),
                          child: isAddress
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: RichText(
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                              text: TextSpan(
                                                text: 'Delivering to : ',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                    text: address.fullName,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            '\n${address.flat}, ${address.area}, ${address.city},${address.flat}, ${address.pincode}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                '\nPhone : ${address.phone}',
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _addressList(context);
                                        // Get.to(() => MyAddress(),
                                        //     transition: Transition.rightToLeft,
                                        //     arguments: true);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: HexColor('#FDE7CE'),
                                        radius: 18,
                                        child: Icon(
                                          Icons.edit_location_alt,
                                          color: HexColor('#F76436'),
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Add address',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    CircleAvatar(
                                      backgroundColor: HexColor('#FDE7CE'),
                                      radius: 18,
                                      child: Icon(
                                        Icons.add_location_alt,
                                        color: HexColor('#F76436'),
                                        size: 22,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text('Error:Please try again!'),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget addressListWidget(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .45,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firebaseFirestore
            .collection(addressesCollection)
            .where('uid', isEqualTo: firebaseAuth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: MyProgressIndicator(),
            );
          } else {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Select address',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setAddress(
                                Address.fromSnap(snapshot.data!.docs[index]));
                            Navigator.of(context).pop();
                          },
                          child: Card(
                            elevation: 0,
                            color: cardBg,
                            margin: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RichText(
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                      text: TextSpan(
                                          text: snapshot.data!.docs[index]
                                              ['fullName'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: textColor),
                                          children: [
                                            TextSpan(
                                              text:
                                                  '\n${snapshot.data!.docs[index]['flat']}, ${snapshot.data!.docs[index]['area']}, ${snapshot.data!.docs[index]['city']},${snapshot.data!.docs[index]['flat']}, ${snapshot.data!.docs[index]['pincode']}\nPhone : ${snapshot.data!.docs[index]['phone']}',
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: GradientElevatedButton(
                      buttonName: 'Add Address',
                      onPressed: () {
                        Navigator.of(context).pop();
                        Get.to(() => const AddAddress(),
                            transition: Transition.rightToLeft);
                      },
                      height: 44,
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('Error occured'));
            }
          }
        },
      ),
    );
  }
}
