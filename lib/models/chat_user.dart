import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  ChatUser({
    required this.images,
    required this.name,
    required this.about,
    required this.createdAt,
    required this.id,
    required this.lastActive,
    required this.isOnline,
    required this.pushToken,
    required this.email,
  });
  late String images;
  late String name;
  late String about;
  late String createdAt;
  late String id;
  late String lastActive;
  late bool isOnline;
  late String pushToken;
  late String email;

  ChatUser.fromJson(Map<String, dynamic> json) {
    images = json['images'] ?? '';
    name = json['name'] ?? '';
    about = json['about'] ?? '';
    createdAt = json['created_at'] ?? '';
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    isOnline = json["is_online"] ?? false;
    pushToken = json['push_token'] ?? '';
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['images'] = images;
    data['name'] = name;
    data['about'] = about;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['is_online'] = isOnline;
    data['push_token'] = pushToken;
    data['email'] = email;
    return data;
  }


  // chat gpt 
  ChatUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    images = data['images'] ?? '';
    name = data['name'] ?? '';
    about = data['about'] ?? '';
    createdAt = data['created_at'] ?? '';
    id = data['id'] ?? '';
    lastActive = data['last_active'] ?? '';
    isOnline = data["is_online"] ?? '';
    pushToken = data['push_token'] ?? '';
    email = data['email'] ?? '';
  }

  static fromSnapshot(QueryDocumentSnapshot<Object?> doc) {}

  map(Function(dynamic e) param0) {}
}
