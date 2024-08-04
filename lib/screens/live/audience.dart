import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pherico/config/config.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/resources/live_resource.dart';
import 'package:pherico/resources/user_resource.dart';
import 'package:pherico/screens/clicky/clicky_product_list.dart';
import 'package:pherico/utils/color.dart';
import 'package:pherico/widgets/global/gradient_circle.dart';
import 'package:pherico/widgets/global/my_progress_indicator.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class Audience extends StatefulWidget {
  final String liveId;
  final List productIds;

  const Audience({Key? key, required this.liveId, required this.productIds})
      : super(key: key);

  @override
  State<Audience> createState() => _Audience();
}

class _Audience extends State<Audience> {
  bool isProcessing = true;
  @override
  void initState() {
    super.initState();
    saveUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isProcessing
          ? const MyProgressIndicator()
          : Stack(
              children: [
                ZegoUIKitPrebuiltLiveStreaming(
                  controller: ZegoUIKitPrebuiltLiveStreamingController(),
                  appID: Config.appId,
                  appSign: Config.appSign,
                  userID: firebaseAuth.currentUser!.uid,
                  userName: UserResource.myself.username,
                  liveID: widget.liveId,
                  config: ZegoUIKitPrebuiltLiveStreamingConfig.audience()
                    ..innerText.startLiveStreamingButton = 'Join now'
                    ..effectConfig = ZegoEffectConfig.none()
                    ..turnOnMicrophoneWhenJoining = false
                    ..audioVideoViewConfig.showUserNameOnView = false
                    ..confirmDialogInfo = ZegoDialogInfo(
                      title: "Leave confirm",
                      message: "Do you want to exit from live?",
                      cancelButtonName: "Cancel",
                      confirmButtonName: "Confirm",
                    )
                    // ..onLeaveLiveStreaming = () {
                    //   Get.back();
                    // }
                    ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
                      maxCount: 1,
                      audienceExtendButtons: [
                        ZegoMenuBarExtendButton(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, right: 0),
                            child: InkWell(
                              onTap: () {
                                Get.to(() => const ClickyProductList(),
                                    arguments: widget.productIds,
                                    transition: Transition.leftToRight);
                              },
                              child: GradientCircle(
                                radius: 36,
                                child: Center(
                                  child: SvgPicture.asset(
                                      'assets/images/icons/product.svg',
                                      height: 24,
                                      colorFilter: svgColor()),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                    ..turnOnMicrophoneWhenJoining = false
                    ..turnOnCameraWhenJoining = false,
                ),
              ],
            ),
    );
  }

  saveUser() {
    setState(() {
      isProcessing = true;
    });
    try {
      LiveResource.saveJoinUser(
          docId: widget.liveId, userId: firebaseAuth.currentUser!.uid);
    } catch (e) {}
    setState(() {
      isProcessing = false;
    });
  }
}
