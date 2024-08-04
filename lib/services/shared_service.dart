import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:pherico/models/login_response.dart';

class SharedService {
  static Future<bool> isLoggedIn() async {
    var isKeyExist = await APICacheManager().isAPICacheKeyExist('logged_user');
    return isKeyExist;
  }

  static Future<LoginResponse?> loggedUser() async {
    var isKeyExist = await APICacheManager().isAPICacheKeyExist('logged_user');
    if (isKeyExist) {
      var data = await APICacheManager().getCacheData('logged_user');
      return loginResponse(data.syncData);
    }
    return null;
  }

  static Future<void> saveLoginDetails(LoginResponse model) async {
    APICacheDBModel cacheDBModel = APICacheDBModel(
        key: 'logged_user', syncData: jsonEncode(model.toJson()));

    await APICacheManager().addCacheData(cacheDBModel);
  }

  static Future<void> logout(BuildContext context) async {
    await APICacheManager().deleteCache('logged_user');
    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
