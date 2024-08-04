import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pherico/widgets/global/image_popup.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class AccountCoverSeller extends StatelessWidget {
  final VoidCallback onTap;
  final String cover;
  final String profile;
  const AccountCoverSeller(
      {super.key,
      required this.onTap,
      required this.cover,
      required this.profile});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .24,
      child: Stack(
        children: [
          CachedNetworkImage(
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width,
            imageUrl: cover,
            fit: BoxFit.cover,
          ),
          Positioned(
            right: 12,
            top: 12,
            child: InkWell(
              onTap: onTap,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: HexColor('#EBEBEB'),
                child: const Icon(
                  CupertinoIcons.ellipsis_vertical,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => ImagePopup(image: profile),
                  );
                },
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: profile,
                    fit: BoxFit.cover,
                    height: 70,
                    width: 70,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, size: 40),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
