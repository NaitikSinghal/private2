import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/config/my_color.dart';
import 'package:pherico/models/clicky.dart';
import 'package:pherico/resources/clicky_resource.dart';
import 'package:pherico/resources/saved_items_resource.dart';
import 'package:pherico/resources/seller_resources.dart';
import 'package:pherico/screens/clicky/clicky_comments.dart';
import 'package:pherico/screens/clicky/clicky_product_list.dart';
import 'package:pherico/screens/seller_profile.dart';
import 'package:pherico/utils/border.dart';
import 'package:pherico/utils/text_input.dart';
import 'package:pherico/utils/toast_extension.dart';
import 'package:pherico/widgets/buttons/gradient_elevated_button.dart';
import 'package:pherico/widgets/buttons/outlined_button.dart';
import 'package:pherico/widgets/global/gradient_circle.dart';
import 'package:pherico/widgets/global/inside_circle_icon.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:pherico/widgets/global/read_more.dart';
import 'package:pherico/widgets/global/my_bottom_sheet.dart';
import 'package:pherico/widgets/global/rounded_image.dart';

import 'package:pherico/widgets/reel/play_pause_animation.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:video_player/video_player.dart';

class ClickyPlayerItem extends StatefulWidget {
  final Clicky clicky;
  const ClickyPlayerItem({super.key, required this.clicky});

  @override
  State<ClickyPlayerItem> createState() => _ClickyPlayerItemState();
}

class _ClickyPlayerItemState extends State<ClickyPlayerItem> {
  late VideoPlayerController _controller;
  late Future<void> _initializedFutureVideoPlayer;

  bool isPaused = false;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.clicky.videoUrl);
    _initializedFutureVideoPlayer = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1);
    _controller.play();
    // clickyController.watched(widget.clicky.id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _controller.setVolume(0.0);
    _controller.pause();
    super.deactivate();
  }

  final TextEditingController _textFieldController = TextEditingController();
  Future<void> _displayClickyReportDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          titleTextStyle: TextStyle(fontSize: 16, color: brownText),
          shape: borderShape(radius: 12),
          title: const Text('Write your issue here'),
          content: TextFormField(
            controller: _textFieldController,
            maxLines: 4,
            decoration: inputDecoration('Say something...'),
          ),
          actionsPadding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyOutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    buttonName: 'Cancel'),
                GradientElevatedButton(
                  buttonName: 'Submit',
                  onPressed: () {
                    if (_textFieldController.text.trim().isEmpty) {
                      context.showToast('Field can not be empty',
                          isError: true);
                    } else {
                      ClickyResource.reportClicky(
                          _textFieldController.text.trim(),
                          widget.clicky.userId,
                          widget.clicky.id);
                      Get.back();
                      context.showToast('Submitted');
                      _textFieldController.text = '';
                    }
                  },
                  height: 41,
                )
              ],
            )
          ],
        );
      },
    );
  }

  showToast(String msg, bool isError) {
    context.showToast(msg, isError: isError);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onDoubleTap: () {
        ClickyResource.likeReel(widget.clicky.id);
      },
      onTap: (() {
        setState(() {
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        });
      }),
      child: Stack(
        children: [
          FutureBuilder(
            future: _initializedFutureVideoPlayer,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  width: size.width,
                  height: size.height - 50,
                  decoration: const BoxDecoration(color: Colors.black),
                  child: VideoPlayer(_controller),
                );
              } else {
                return Container(
                  width: size.width,
                  height: size.height,
                  decoration: const BoxDecoration(color: Colors.black),
                  child: const MyProgressIndicator(),
                );
              }
            },
          ),
          isPaused ? const PlayPauseAnimation() : Container(),
          Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Card(
                              elevation: 0,
                              color: const Color.fromARGB(80, 22, 44, 33),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ReadMore(
                                  textColor: Colors.white,
                                  text: widget.clicky.caption,
                                  trimLine: 3,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _controller.pause();
                                    Get.to(
                                      () => SellerProfile(
                                        sellerId: widget.clicky.userId,
                                      ),
                                      transition: Transition.leftToRight,
                                    );
                                  },
                                  child: RoundedImage(
                                    image: widget.clicky.profile,
                                    isNetwork: true,
                                    radius: 60,
                                    height: 60,
                                    width: 60,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.clicky.sellerName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          height: 1,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      widget.clicky.userId ==
                                              firebaseAuth.currentUser!.uid
                                          ? Container()
                                          : GradientElevatedButton(
                                              buttonName: 'Follow',
                                              width: 90,
                                              height: 26,
                                              onPressed: (() {
                                                followSeller(
                                                  widget.clicky.userId,
                                                );
                                              }),
                                            )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: size.height / 2.5,
                      margin: EdgeInsets.only(top: size.height / 5, right: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              ClickyResource.likeReel(widget.clicky.id);
                            },
                            icon: SvgPicture.asset(
                              'assets/images/navigation-icon/${widget.clicky.likes.contains(firebaseAuth.currentUser!.uid) ? 'heart_white_fill.svg' : 'heart-white-outline.svg'}',
                              height: 28,
                            ),
                          ),
                          Text(
                            widget.clicky.likes.length.toString(),
                            style: TextStyle(color: white, fontSize: 12),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _controller.pause();
                                  Get.to(
                                      () => ClickyComments(
                                          postId: widget.clicky.id),
                                      transition: Transition.leftToRight);
                                },
                                icon: SvgPicture.asset(
                                  'assets/images/navigation-icon/comment.svg',
                                  height: 28,
                                ),
                              ),
                              Text(
                                widget.clicky.commentCount.toString(),
                                style: TextStyle(color: white, fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                shape: bottomSheetBorder,
                                builder: (ctx) => MyBottomSheet(
                                  child: bottomSheetMenu(context),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.more_vert,
                              color: white,
                              size: 36,
                            ),
                          ),
                          const SizedBox(
                            height: 11,
                          ),
                          InkWell(
                            onTap: () {
                              _controller.pause();
                              Get.to(() => const ClickyProductList(),
                                  arguments: widget.clicky.productIds,
                                  transition: Transition.rightToLeft);
                            },
                            child: const GradientCircle(
                              radius: 36,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.breakfast_dining,
                                    size: 24,
                                  ),
                                  Text(
                                    'view\nproduct',
                                    style: TextStyle(
                                      fontSize: 12,
                                      height: 1,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomSheetMenu(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: InsideCircleIcon(
                icon: CupertinoIcons.bookmark_solid,
                label: 'Save',
                fontSize: 16,
                radius: 18,
                onTap: () async {
                  try {
                    String res = await SavedItemsResource()
                        .saveClickies(widget.clicky.id);
                    if (res == 'success') {
                      // ignore: use_build_context_synchronously
                      context.showToast("Clicky saved");
                    } else {
                      // ignore: use_build_context_synchronously
                      context.showToast(
                        isError: true,
                        "Failed to save",
                      );
                    }
                  } catch (e) {
                    context.showToast(
                      isError: true,
                      "Failed to save",
                    );
                  }
                  Get.back();
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        const Divider(
          thickness: 1,
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          horizontalTitleGap: 0,
          minVerticalPadding: 0,
          visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
          leading: Icon(
            CupertinoIcons.paperplane_fill,
            color: HexColor('#292D32'),
          ),
          title: const Text('Share to...'),
        ),
        firebaseAuth.currentUser!.uid == widget.clicky.userId
            ? Container()
            : const Divider(
                thickness: 1,
              ),
        firebaseAuth.currentUser!.uid == widget.clicky.userId
            ? Container()
            : ListTile(
                onTap: () async {
                  _controller.pause();
                  _displayClickyReportDialog(context);
                },
                contentPadding: const EdgeInsets.all(0),
                horizontalTitleGap: 2,
                minVerticalPadding: 0,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
                leading: Icon(
                  CupertinoIcons.exclamationmark_circle_fill,
                  size: 30,
                  color: HexColor('#F6212E'),
                ),
                title: Text(
                  'Report this clicky',
                  style: TextStyle(
                    color: HexColor('#F6212E'),
                  ),
                ),
              ),
      ],
    );
  }
}
