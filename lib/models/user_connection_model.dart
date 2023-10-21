class UserConnection {
  UserConnection({
    required this.connectionId,
    required this.fromId,
    required this.toId,
    required this.status,
    required this.sent,
  });
  late String connectionId;
  late String fromId;
  late String toId;
  late String status;
  late String sent;

  UserConnection.fromJson(Map<String, dynamic> json) {
    connectionId = json['connectionId'] ?? '';
    fromId = json['fromId'] ?? '';
    toId = json['toId'] ?? '';
    status = json['status'] ?? '';
    sent = json['sent'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['connectionId'] = connectionId;
    data['fromId'] = fromId;
    data['toId'] = toId;
    data['status'] = status;
    data['sent'] = sent;

    return data;
  }
}
