class Status {
  Status({
    required this.uId,
    required this.title,
    required this.link,
    required this.type,
    required this.sent,
  });
  late final String uId;
  late final String title;
  late final String link;
  late final StatusType type;
  late final String sent;

  Status.fromJson(Map<String, dynamic> json) {
    uId = json['uId'].toString();
    title = json['title'].toString();
    link = json['link'].toString();
    type = json['type'].toString() == StatusType.image.name
        ? StatusType.image
        : StatusType.text;
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uId'] = uId;
    data['title'] = title;
    data['link'] = link;
    data['type'] = type.name;
    data['sent'] = sent;
    return data;
  }
}

enum StatusType { text, image }
