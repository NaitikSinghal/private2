import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LiveViewLabel extends StatelessWidget {
  final String hostName;
  final String hostProfile;
  final String liveTitle;
  const LiveViewLabel(
      {super.key,
      required this.hostName,
      required this.hostProfile,
      required this.liveTitle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.42,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: CachedNetworkImage(
                  imageUrl: hostProfile,
                  fit: BoxFit.cover,
                  height: 28,
                  width: 28,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  hostName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: true,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          Text(
            liveTitle,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
