import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/helpers/chat_time_formatter.dart';
import 'package:pherico/models/seller/seller.dart';
import 'package:pherico/resources/chat_resource.dart';
import 'package:pherico/screens/chats/chat.dart';
import 'package:pherico/widgets/global/image_popup.dart';
import 'package:pherico/widgets/global/rounded_image.dart';

class ChatUserCard extends StatelessWidget {
  final Seller seller;
  const ChatUserCard({super.key, required this.seller});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ChatResource.getLastMessage(seller.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return InkWell(
            onTap: () {
              Get.to(() => const Chat(),
                  transition: Transition.rightToLeft, arguments: seller);
            },
            child: Card(
              elevation: 1,
              color: cardBg,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (_) => ImagePopup(image: seller.cover));
                      },
                      child: RoundedImage(
                        height: 50,
                        width: 50,
                        radius: 25,
                        image: seller.cover,
                        isNetwork: true,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  seller.shopName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              snapshot.data!.docs.length > 0
                                  ? Text(
                                      ChatTimeFormatter.getLastMessageTime(
                                          context,
                                          snapshot.data!.docs[0]['sent'] ?? ''),
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: snapshot.data!.docs[0]
                                                      ['fromid'] !=
                                                  firebaseAuth.currentUser!.uid
                                              ? snapshot.data!.docs[0]
                                                          ['read'] ==
                                                      ''
                                                  ? green
                                                  : greyText
                                              : greyText),
                                      textAlign: TextAlign.end,
                                    )
                                  : Container(),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          snapshot.data!.docs.isNotEmpty
                              ? Text(
                                  snapshot.data!.docs[0]['type'] == 'image'
                                      ? 'Image'
                                      : snapshot.data!.docs[0]['message']
                                          .toString(),
                                  maxLines: 1,
                                  style: TextStyle(color: greyText),
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Container(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
