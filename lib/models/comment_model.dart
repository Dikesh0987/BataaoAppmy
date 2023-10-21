class Comments {
  Comments({
    required this.pId,
    required this.uId,
    required this.comment,
    required this.sent,
  });
  late final String pId;
  late final String uId;
  late final String comment;
  late final String sent;

  Comments.fromJson(Map<String, dynamic> json) {
    pId = json['pId'].toString();
    uId = json['uId'].toString();
    comment = json['comment'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pId'] = pId;
    data['uId'] = uId;
    data['comment'] = comment;
    data['sent'] = sent;
    return data;
  }
}
