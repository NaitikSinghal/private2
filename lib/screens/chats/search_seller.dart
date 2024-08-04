import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/seller/seller.dart';
import 'package:pherico/screens/chats/user_search_card.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';

import '../../config/my_color.dart';

class SearchSeller extends StatefulWidget {
  const SearchSeller({super.key});

  @override
  State<SearchSeller> createState() => _SearchSellerState();
}

class _SearchSellerState extends State<SearchSeller> {
  Query<Map<String, dynamic>> _query = firebaseFirestore
      .collection(storeCollection)
      .where('uid', isNotEqualTo: firebaseAuth.currentUser!.uid);
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: CustomAppbar(
          title: '',
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 80,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: _searchController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      filled: true,
                      fillColor: cardBg,
                      labelText: 'Search seller',
                      labelStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
                      suffixIcon: _isSearching
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _query = firebaseFirestore
                                      .collection(storeCollection)
                                      .where('uid',
                                          isNotEqualTo:
                                              firebaseAuth.currentUser!.uid);
                                  _searchController.text = '';
                                  _isSearching = false;
                                  FocusManager.instance.primaryFocus!.unfocus();
                                });
                              },
                              child: const Icon(
                                  CupertinoIcons.clear_circled_solid),
                            )
                          : const Icon(
                              Icons.search,
                              color: Colors.black26,
                            ),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        borderSide: BorderSide(width: 1, color: greyColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: greyColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _isSearching = true;
                      });
                      if (val.length > 2) {
                        setState(
                          () {
                            _query = firebaseFirestore
                                .collection(storeCollection)
                                .where('shopName', isGreaterThanOrEqualTo: val)
                                .where('shopName',
                                    isLessThanOrEqualTo: '$val\uf7ff');
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: FirestoreQueryBuilder<Map<String, dynamic>>(
                query: _query,
                pageSize: 20,
                builder: (context, snapshot, _) {
                  if (snapshot.isFetching) {
                    return const Center(child: MyProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong!'),
                    );
                  }
                  if (snapshot.docs.isEmpty) {
                    return const Center(
                      child: Text('No seller found'),
                    );
                  }
                  final List<Seller> seller = snapshot.docs
                      .map((e) => Seller.fromMap(e.data()))
                      .toList();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: snapshot.docs.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (snapshot.hasMore &&
                            index + 1 == snapshot.docs.length) {
                          snapshot.fetchMore();
                        }
                        return UserSearchCard(seller: seller[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
