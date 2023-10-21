class Bookmark {
  Bookmark({
    required this.pId,
    required this.sent,
  });
  late final String pId;
  late final String sent;

  Bookmark.fromJson(Map<String, dynamic> json) {
    pId = json['pId'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pId'] = pId;
    data['sent'] = sent;
    return data;
  }
}
