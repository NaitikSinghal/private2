import 'dart:convert';

RegisterResponse registerResponse(String str) =>
    RegisterResponse.fromJson(json.decode(str));

class RegisterResponse {
  RegisterResponse({
    required this.message,
    required this.data,
  });
  late final String message;
  late final Data? data;

  RegisterResponse.fromJson(Map<String, dynamic> json) {
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
    required this.name,
    required this.email,
    required this.phone,
    required this.profile,
    required this.token,
    required this.status,
  });
  late final String id;
  late final String name;
  late final String email;
  late final String phone;
  late final String profile;
  late final String token;
  late final bool status;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    profile = json['profile'];
    token = json['token'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['profile'] = profile;
    data['token'] = token;
    data['status'] = status;
    return data;
  }
}
