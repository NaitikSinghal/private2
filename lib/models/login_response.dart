import 'dart:convert';

LoginResponse loginResponse(String str) =>
    LoginResponse.fromJson(json.decode(str));

class LoginResponse {
  LoginResponse({
    required this.message,
    required this.data,
  });
  late final String message;
  late final Data? data;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message;
    data['data'] = data;
    return data;
  }
}

class Data {
  Data({
    required this.id,
    required this.email,
    required this.phone,
    required this.profile,
    required this.token,
  });
  late final String id;
  late final String email;
  late final String phone;
  late final String profile;
  late final String token;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    phone = json['phone'];
    profile = json['profile'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['phone'] = phone;
    data['profile'] = profile;
    data['token'] = token;
    return data;
  }
}
