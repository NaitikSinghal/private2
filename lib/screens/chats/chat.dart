import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/helpers/chat_time_formatter.dart';
import 'package:pherico/models/message.dart';
import 'package:pherico/models/seller/seller.dart';
import 'package:pherico/resources/chat_resource.dart';
import 'package:pherico/screens/seller_profile.dart';
import 'package:pherico/utils/border.dart';
import 'package:pherico/utils/crop_image.dart';
import 'package:pherico/utils/toast_extension.dart';
import 'package:pherico/widgets/global/image_popup.dart';
import 'package:pherico/widgets/global/inside_circle_icon.dart';
import 'package:pherico/widgets/global/my_bottom_sheet.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:pherico/widgets/global/rounded_image.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'dart:math' as math;

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _inputController = TextEditingController();
  bool _isLoading = false;
  bool _isFirstMessageLoading = false;
  bool isEmpty = false;

  @override
  void dispose() {
    super.dispose();
    _inputController.dispose();
  }

  showToast(String msg, bool isError) {
    context.showToast(msg, isError: isError);
  }

  _selectFile(BuildContext context, sellerId, type) async {
    if (type == 'gallery') {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        Uint8List? croppedFile = await cropImage(pickedFile);
        if (croppedFile != null) {
          setState(() {
            _isLoading = true;
          });
          if (isEmpty) {
            await ChatResource.sendFirstFile(sellerId, croppedFile);
          } else {
            await ChatResource.sendFile(sellerId, croppedFile);
          }
          setState(() {
            _isLoading = false;
          });
        }
      }
    }

    if (type == 'camera') {
      final cameraFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (cameraFile != null) {
        Uint8List? croppedFile0 = await cropImage(cameraFile);
        if (croppedFile0 != null) {
          setState(() {
            _isLoading = true;
          });
          await ChatResource.sendFile(sellerId, croppedFile0);
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Seller seller = ModalRoute.of(context)!.settings.arguments as Seller;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
            elevation: 1,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Get.back();
              },
              iconSize: 20,
              padding: const EdgeInsets.fromLTRB(0, 6, 0, 2),
            ),
            titleSpacing: 0,
            title: _appBar(seller, context)),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: HexColor('#ffffff'),
          child: Column(
            children: [
              Expanded(
                child: FirestoreListView<Map<String, dynamic>>(
                    pageSize: 30,
                    reverse: true,
                    query: ChatResource.getAllMessages(seller.uid),
                    loadingBuilder: (context) {
                      return const Center(child: MyProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text('Something went wrong!'),
                      );
                    },
                    emptyBuilder: (context) {
                      isEmpty = true;
                      return const Center(
                        child: Text(
                          'Say Hii 👋',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                    itemBuilder: (context, snapshot) {
                      isEmpty = false;
                      // final data = snapshot.data();
                      Message messageData = Message.fromJson(snapshot.data());
                      return messageData.toid == firebaseAuth.currentUser!.uid
                          ? receiverMessage(context, messageData)
                          : senderMessage(context, messageData);
                    }),
              ),
              if (_isLoading)
                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: MyProgressIndicator(),
                  ),
                ),
              _bottomInput(seller, context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar(seller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (_) => ImagePopup(image: seller.cover));
            },
            child: RoundedImage(
              height: 48,
              width: 48,
              radius: 22,
              image: seller.cover,
              isNetwork: true,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: () {
              Get.to(
                () => SellerProfile(sellerId: seller.uid as String),
                transition: Transition.rightToLeft,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seller.shopName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16),
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: ChatResource.getSellerInfo(seller.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          return Text(
                            snapshot.data!.docs[0]['isOnline']
                                ? 'online'
                                : ChatTimeFormatter.getLastActiveTime(context,
                                    snapshot.data!.docs[0]['lastActive']),
                            style: TextStyle(
                              color: snapshot.data!.docs[0]['isOnline']
                                  ? Colors.green
                                  : Colors.grey,
                              fontSize: 12,
                            ),
                          );
                        } else {
                          return const Text(
                            'Last seen not available',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return const Text(
                          'Last seen not available',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        );
                      } else {
                        return const Text(
                          'Error to get Last seen',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        );
                      }
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomInput(Seller seller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: Card(
                color: cardBg,
                elevation: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _inputController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          filled: true,
                          fillColor: Colors.transparent,
                          labelText: 'Type here',
                          labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.transparent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            _selectFile(context, seller.uid, 'gallery');
                          },
                          child: Icon(
                            CupertinoIcons.doc_fill,
                            size: 20,
                            color: gradient1,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        InkWell(
                          onTap: () {
                            _selectFile(context, seller.uid, 'camera');
                          },
                          child: Icon(
                            CupertinoIcons.photo_camera_solid,
                            size: 20,
                            // color: HexColor('#8F8F8F'),
                            color: gradient1,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          _isFirstMessageLoading
              ? const MyProgressIndicator()
              : InkWell(
                  onTap: () async {
                    if (_inputController.text != '') {
                      if (isEmpty) {
                        setState(() {
                          _isFirstMessageLoading = true;
                        });
                        await ChatResource.sendFirstMessage(
                            seller.uid,
                            seller.pushToken,
                            seller.shopName,
                            _inputController.text);
                        _inputController.text = '';
                        setState(() {
                          _isFirstMessageLoading = false;
                        });
                      } else {
                        await ChatResource.sendMessage(
                            seller.uid,
                            seller.pushToken,
                            seller.shopName,
                            _inputController.text);
                        _inputController.text = '';
                      }
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: HexColor('#EBEBEB'),
                    radius: 22,
                    child: Transform.rotate(
                      angle: 70,
                      child: Icon(
                        CupertinoIcons.paperplane_fill,
                        color: HexColor('#4318FF'),
                        size: 24,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget senderMessage(BuildContext context, Message data) {
    return data.isDelete == ''
        ? InkWell(
            onLongPress: () async {
              await bottomSheet(data, context);
            },
            child: ChatBubble(
              clipper: ChatBubbleClipper6(type: BubbleType.sendBubble),
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(top: 12),
              backGroundColor: HexColor('#CBA7E1'),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(20, 15),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.centerLeft),
                      icon: Icon(
                        data.read == '' ? Icons.done : Icons.done_all,
                        color: data.read == '' ? greyText : green,
                        size: 16,
                      ),
                      label: Text(
                        ChatTimeFormatter.getFromattedTime(context, data.sent),
                        style: TextStyle(
                            color: greyColor,
                            fontSize: 12,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    data.type == Type.image
                        ? Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: FullScreenWidget(
                              disposeLevel: DisposeLevel.Low,
                              child: CachedNetworkImage(
                                imageUrl: data.message,
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.image,
                                  size: 70,
                                ),
                                placeholder: (context, url) =>
                                    const MyProgressIndicator(),
                              ),
                            ),
                          )
                        : Text(
                            data.message,
                            overflow: TextOverflow.clip,
                          ),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

  Widget receiverMessage(BuildContext context, Message data) {
    if (data.read == '') {
      ChatResource.updateMessageReadStatus(data.fromid, data.messageId);
    }
    return InkWell(
      onLongPress: () async {
        await bottomSheet(data, context);
      },
      child: Transform(
        transform: Matrix4.rotationX(math.pi),
        alignment: Alignment.center,
        child: ChatBubble(
          margin: const EdgeInsets.only(bottom: 8.0),
          backGroundColor: HexColor('#EAECF0'),
          clipper: ChatBubbleClipper6(type: BubbleType.receiverBubble),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Transform(
              transform: Matrix4.rotationX(math.pi),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(20, 15),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    icon: Icon(
                      data.read == '' ? Icons.done : Icons.done_all,
                      color: data.read == '' ? greyText : green,
                      size: 16,
                    ),
                    label: Text(
                      ChatTimeFormatter.getFromattedTime(context, data.sent),
                      style: TextStyle(
                          color: greyScale,
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  data.type == Type.image
                      ? CachedNetworkImage(
                          imageUrl: data.message,
                          errorWidget: (context, url, error) => const Icon(
                            Icons.image,
                            size: 70,
                          ),
                          placeholder: (context, url) =>
                              const MyProgressIndicator(),
                        )
                      : Text(
                          data.message,
                          overflow: TextOverflow.clip,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Widget> bottomSheet(Message data, BuildContext context) async {
    String sent = ChatTimeFormatter.getMessageTime(data.sent, context);
    String read = '';
    if (data.read == '') {
      read = 'Not seen yet';
    } else {
      read = ChatTimeFormatter.getMessageTime(data.sent, context);
    }

    return await showModalBottomSheet(
      context: context,
      shape: bottomSheetBorder,
      builder: (ctx) => MyBottomSheet(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: data.type == Type.image
                      ? InsideCircleIcon(
                          icon: Icons.download,
                          label: 'Download Image',
                          fontSize: 16,
                          onTap: () async {
                            Navigator.of(context).pop();
                            try {
                              await GallerySaver.saveImage(data.message,
                                      albumName: 'Pherico')
                                  .then((value) {
                                if (value != null && value) {
                                  context.showToast('Saved in gallery');
                                }
                              });
                            } catch (error) {
                              context.showToast(
                                  isError: true, 'Failed to save image');
                            }
                          },
                        )
                      : InsideCircleIcon(
                          icon: CupertinoIcons.square_fill_on_square_fill,
                          label: 'Copy Text',
                          fontSize: 16,
                          radius: 18,
                          onTap: () async {
                            await Clipboard.setData(
                                    ClipboardData(text: data.message))
                                .then((value) {
                              Navigator.of(context).pop();
                            });
                          },
                        ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            const Divider(
              thickness: 1,
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Icon(
                  CupertinoIcons.checkmark_square_fill,
                  color: HexColor('#292D32'),
                  size: 28,
                ),
                const SizedBox(
                  width: 22,
                ),
                Flexible(
                  child: Text(
                    'Sent at : $sent',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 18,
            ),
            Row(
              children: [
                Icon(
                  CupertinoIcons.eye_fill,
                  color: HexColor('#292D32'),
                  size: 28,
                ),
                const SizedBox(
                  width: 22,
                ),
                Flexible(
                  child: Text(
                    'Read at : $read',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            data.fromid == firebaseAuth.currentUser!.uid
                ? Column(
                    children: [
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      InkWell(
                        onTap: () async {
                          Navigator.of(context).pop();
                          String res = await ChatResource.deleteMessage(
                              data.toid, data.messageId);
                          if (res == 'success') {
                            showToast('Deleted', false);
                          } else {
                            showToast(
                              'Failed to delete',
                              true,
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              color: HexColor('#F6212E'),
                              size: 28,
                            ),
                            const SizedBox(
                              width: 22,
                            ),
                            Flexible(
                              child: Text(
                                data.type == Type.image
                                    ? 'Delete this image'
                                    : 'Delete this message',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: HexColor('#F6212E'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      )
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
