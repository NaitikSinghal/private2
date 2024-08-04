class Orders {
  late final String shippingName;
  late final String orderId;
  late final String docId;
  late final String billingPincode;
  late final String received;
  late final String shippingPhone;
  late final String delivered;
  late final String uid;
  late final String pick;
  late final String shippingAddress;
  late final String billingName;
  late final String billingAddress;
  late final String billingPhone;
  late final String weight;
  late final String status;
  late final String shippingPincode;

  Orders(
      {required this.shippingName,
      required this.orderId,
      required this.docId,
      required this.billingPincode,
      required this.received,
      required this.shippingPhone,
      required this.delivered,
      required this.uid,
      required this.pick,
      required this.shippingAddress,
      required this.billingName,
      required this.billingAddress,
      required this.billingPhone,
      required this.status,
      required this.weight,
      required this.shippingPincode});

  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
      shippingName: json['shippingName'],
      orderId: json['orderId'],
      docId: json['docId'],
      billingPincode: json['billingPincode'],
      received: json['received'],
      shippingPhone: json['shippingPhone'],
      delivered: json['delivered'],
      uid: json['uid'],
      pick: json['pick'],
      shippingAddress: json['shippingAddress'],
      billingName: json['billingName'],
      billingAddress: json['billingAddress'],
      billingPhone: json['billingPhone'],
      status: json['status'],
      weight: json['weight'],
      shippingPincode: json['shippingPincode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shippingName'] = shippingName;
    data['orderId'] = orderId;
    data['docId'] = docId;
    data['billingPincode'] = billingPincode;
    data['received'] = received;
    data['shippingPhone'] = shippingPhone;
    data['delivered'] = delivered;
    data['uid'] = uid;
    data['pick'] = pick;
    data['shippingAddress'] = shippingAddress;
    data['billingName'] = billingName;
    data['billingAddress'] = billingAddress;
    data['billingPhone'] = billingPhone;
    data['status'] = status;
    data['weight'] = weight;
    data['shippingPincode'] = shippingPincode;
    return data;
  }
}
