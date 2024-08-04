import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/models/seller/seller.dart';
import 'package:pherico/resources/chat_resource.dart';
import 'package:pherico/screens/chats/chat_user_card.dart';
import 'package:pherico/widgets/global/app_bar.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List<Seller> _chatsList = [];
  final List<Seller> _searchList = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: CustomAppbar(
          title: 'Chats',
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              searchInput(),
              const Text(
                'All chats',
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: ChatResource.getChatIds(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: MyProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Something went wrong!'),
                      );
                    } else if (snapshot.hasData &&
                        snapshot.data!.docs.isNotEmpty) {
                      List<String> userIds =
                          snapshot.data!.docs.map((e) => e.id).toList();
                      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: ChatResource.getAllUsers(userIds),
                        builder: (contex, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(child: MyProgressIndicator());
                          }
                          if (userSnapshot.hasData &&
                              userSnapshot.data!.docs.isNotEmpty) {
                            final data = userSnapshot.data!.docs;
                            _chatsList = data
                                .map((e) => Seller.fromMap(e.data()))
                                .toList();
                            return ListView.builder(
                              itemCount: _isSearching
                                  ? _searchList.length
                                  : userSnapshot.data!.docs.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ChatUserCard(
                                    seller: _isSearching
                                        ? _searchList[index]
                                        : _chatsList[index]);
                              },
                            );
                          } else {
                            return const Center(
                              child: Text('No chats found'),
                            );
                          }
                        },
                      );
                    } else {
                      return const Center(
                        child: Text('No chats found'),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: gradient1,
      //   onPressed: () {
      //     Get.to(() => const SearchSeller(),
      //         transition: Transition.leftToRight);
      //   },
      //   child: const Icon(
      //     Icons.person,
      //     size: 32,
      //   ),
      // ),
    );
  }

  Widget searchInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
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
            labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            suffixIcon: _isSearching
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _searchController.text = '';
                        _isSearching = false;
                        _searchList.clear();
                        FocusManager.instance.primaryFocus!.unfocus();
                      });
                    },
                    child: const Icon(CupertinoIcons.clear_circled_solid),
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
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          onChanged: (val) {
            _isSearching = true;
            _searchList.clear();
            for (var item in _chatsList) {
              if (item.shopName.toLowerCase().contains(val)) {
                _searchList.add(item);
              }
              setState(() {
                _searchList;
              });
            }
          },
        ),
      ),
    );
  }
}
