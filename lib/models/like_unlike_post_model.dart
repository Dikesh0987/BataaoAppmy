class LikeUnlike {
  LikeUnlike({
    required this.pId,
    required this.likeUnlike,
    required this.sent,
  });
  late final String pId;
  late final bool likeUnlike;
  late final String sent;

  LikeUnlike.fromJson(Map<String, dynamic> json) {
    pId = json['pId'].toString();
    likeUnlike = false;
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pId'] = pId;
    data['likeUnlike'] = likeUnlike;
    data['sent'] = sent;
    return data;
  }
}
