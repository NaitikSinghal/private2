class RegisterModel {
  RegisterModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });
  late final String name;
  late final String email;
  late final String phone;
  late final String password;

  RegisterModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;
    return data;
  }
}
