import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Reel with ChangeNotifier {
  final String id;
  final String sellerName;
  final String desc;
  int likes;
  bool isLike;
  bool isFollow;
  bool isSaved;
  final String src;
  final String profile;
  final String productId;

  Reel({
    required this.id,
    required this.sellerName,
    required this.desc,
    required this.likes,
    this.isLike = false,
    this.isFollow = false,
    this.isSaved = false,
    required this.profile,
    required this.src,
    required this.productId,
  });

  void toggleLike() {
    if (isLike) {
      likes++;
    } else {
      likes--;
    }
    isLike = !isLike;

    notifyListeners();
  }

  void toggleFollow() {
    isFollow = !isFollow;
    notifyListeners();
  }

  void toggleSaved() {
    isSaved = !isSaved;
    notifyListeners();
  }
}
