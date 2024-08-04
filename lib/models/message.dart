class Message {
  late final String fromid;
  late final String toid;
  late final String message;
  late final String read;
  late final String sent;
  late final String messageId;
  late final String isDelete;
  late final Type type;

  Message(
      {required this.fromid,
      required this.toid,
      required this.message,
      required this.read,
      required this.sent,
      required this.messageId,
      required this.type,
      required this.isDelete});

  Message.fromJson(Map<String, dynamic> json) {
    fromid = json['fromid'].toString();
    toid = json['toid'].toString();
    message = json['message'].toString();
    read = json['read'].toString();
    sent = json['sent'].toString();
    messageId = json['messageId'].toString();
    isDelete = json['isDelete'].toString();
    type = json['type'].toString() == 'image' ? Type.image : Type.text;
  }

  Map<String, dynamic> toJson() => {
        "fromid": fromid,
        'toid': toid,
        'message': message,
        'read': read,
        'sent': sent,
        'messageId': messageId,
        'type': type.name,
        'isDelete': isDelete
      };

  factory Message.fromMap(Map<String, dynamic> json) {
    return Message(
      fromid: json['fromid'],
      toid: json["toid"],
      message: json["message"],
      read: json["read"],
      sent: json["sent"],
      messageId: json["messageId"],
      type: json["type"],
      isDelete: json["isDelete"],
    );
  }
}

enum Type { text, image }
