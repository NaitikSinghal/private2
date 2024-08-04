import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pherico/config/config.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/resources/live_resource.dart';
import 'package:pherico/screens/seller/seller_account.dart';
import 'package:pherico/utils/toast_extension.dart';
import 'package:pherico/widgets/buttons/gradient_elevated_button.dart';
import 'package:uuid/uuid.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class Host extends StatefulWidget {
  final String profile;
  final String liveTItle;
  final String categoryId;
  final List productIds;
  final String name;
  final Uint8List thumbnail;

  const Host(
      {Key? key,
      required this.name,
      required this.profile,
      required this.liveTItle,
      required this.categoryId,
      required this.productIds,
      required this.thumbnail})
      : super(key: key);

  @override
  State<Host> createState() => _HostState();
}

class _HostState extends State<Host> {
  bool isProcessing = false;
  String liveId = const Uuid().v1();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
          appID: Config.appId,
          appSign: Config.appSign,
          userID: firebaseAuth.currentUser!.uid,
          userName: widget.name,
          liveID: liveId,
          config: ZegoUIKitPrebuiltLiveStreamingConfig.host()
            ..innerText.startLiveStreamingButton = 'Start Live'
            ..innerText.noHostOnline = 'No host online'
            ..innerText.audioEffectTitle = ''
            ..innerText.audioEffectReverbTitle = ''
            ..effectConfig = ZegoEffectConfig.none()
            ..turnOnMicrophoneWhenJoining = false
            ..audioVideoViewConfig.showUserNameOnView = false
            // ..onLiveStreamingEnded = () {
            //   endLive();
            // }
            ..startLiveButtonBuilder = (context, startLive) {
              return SizedBox(
                height: 46,
                child: isProcessing
                    ? GradientElevatedButton(
                        buttonName: 'Please wait...', onPressed: () {})
                    : GradientElevatedButton(
                        buttonName: 'Start Live',
                        onPressed: () async {
                          await startLiveAndSave(startLive, context);
                        },
                      ),
              );
            }
            ..bottomMenuBarConfig =
                ZegoBottomMenuBarConfig(maxCount: 3, hostButtons: [
              ZegoMenuBarButtonName.switchCameraButton,
              ZegoMenuBarButtonName.toggleMicrophoneButton,
            ])
            ..confirmDialogInfo = ZegoDialogInfo(
              title: "Leave confirm",
              message: "Do you want to stop live?",
              cancelButtonName: "Cancel",
              confirmButtonName: "Confirm",
            )
            // ..onLiveStreamingEnded = () {
            //   Get.off(() => const SellerAccount(),
            //       transition: Transition.leftToRight);
            // }
            ..durationConfig = ZegoLiveDurationConfig(
              onDurationUpdate: (p0) {
                Text(
                  p0.toString(),
                  style: const TextStyle(color: Colors.red),
                );
              },
            )),
    );
  }

  endLive() {
    try {
      LiveResource.endLive(docId: liveId);
    } catch (e) {}
  }

  Future<void> startLiveAndSave(
      Function startLive, BuildContext context) async {
    setState(() {
      isProcessing = true;
    });
    try {
      bool res = await LiveResource.goLive(
          liveId: liveId,
          hostName: widget.name,
          liveTitle: widget.liveTItle,
          hostProfile: widget.profile,
          productIds: widget.productIds,
          categoryId: widget.categoryId,
          thumbnail: widget.thumbnail);
      if (res) {
        startLive();
      } else {
        context.showToast('Enable to create live room');
      }
      setState(() {
        isProcessing = false;
      });
    } catch (e) {
      context.showToast(isError: true, 'Something went wrong');
      setState(() {
        isProcessing = false;
      });
    }
  }
}
