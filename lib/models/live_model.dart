import 'package:cloud_firestore/cloud_firestore.dart';

class LiveModel {
  late final String docId;
  late final String liveId;
  late final bool isLive;
  late final String hostName;
  late final String thumbnail;
  late final String liveTitle;
  late final List members;
  late final String hostId;
  late final String hostProfile;
  late final String startedAt;
  late final String endedAt;
  late final int totalJoined;
  late final List products;
  late final String liveCategory;

  LiveModel({
    required this.docId,
    required this.liveId,
    required this.isLive,
    required this.hostName,
    required this.thumbnail,
    required this.members,
    required this.hostId,
    required this.liveTitle,
    required this.hostProfile,
    required this.startedAt,
    required this.endedAt,
    required this.totalJoined,
    required this.products,
    required this.liveCategory,
  });

  static LiveModel fromJson(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    return LiveModel(
      docId: json['docId'],
      liveId: json['liveId'],
      isLive: json['isLive'],
      liveTitle: json['liveTitle'],
      hostName: json['hostName'],
      thumbnail: json['thumbnail'],
      members: json['members'],
      hostId: json['hostId'],
      hostProfile: json['hostProfile'],
      startedAt: json['startedAt'],
      endedAt: json['endedAt'],
      totalJoined: json['totalJoined'],
      products: json['products'],
      liveCategory: json['liveCategory'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['docId'] = docId;
    data['liveId'] = liveId;
    data['isLive'] = isLive;
    data['hostName'] = hostName;
    data['thumbnail'] = thumbnail;
    data['liveTitle'] = liveTitle;
    data['members'] = members;
    data['hostId'] = hostId;
    data['hostProfile'] = hostProfile;
    data['startedAt'] = startedAt;
    data['endedAt'] = endedAt;
    data['totalJoined'] = totalJoined;
    data['products'] = products;
    data['liveCategory'] = liveCategory;
    return data;
  }
}
