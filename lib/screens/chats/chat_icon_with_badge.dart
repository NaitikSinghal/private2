import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/resources/chat_resource.dart';
import 'package:pherico/screens/chats/chats.dart';

class ChatIconWithBadge extends StatelessWidget {
  const ChatIconWithBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            Get.to(() => const Chats(), transition: Transition.leftToRight);
          },
          // icon: Image.asset(
          //   'assets/images/icons/plain.png',
          // ),
          icon: Icon(
            CupertinoIcons.paperplane_fill,
            color: gradient1,
          ),
        ),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: ChatResource.getChatIds(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container();
            } else {
              return StreamBuilder(
                stream: ChatResource.getMessageCount('da'),
                builder: (context, messageCountSnapshot) {
                  if (messageCountSnapshot.hasError) {
                    return Container();
                  }
                  if (snapshot.hasData) {
                    return Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: const Text(
                          '0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            }
          },
        )
      ],
    );
  }
}
