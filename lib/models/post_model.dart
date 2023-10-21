import 'package:bataao/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    required this.uId,
    required this.pId,
    required this.title,
    required this.link,
    required this.type,
    required this.sent,
    required this.mention,
    required this.location
  });
  late final String uId;
  late final String pId;
  late final String title;
  late final String link;
  late final PostType type;
  late final String sent;
  late final String mention;
  late final String location;

  Post.fromJson(Map<String, dynamic> json) {
    uId = json['uId'].toString();
    pId = json['pId'].toString();
    title = json['title'].toString();
    link = json['link'].toString();
    type = json['type'].toString() == PostType.image.name
        ? PostType.image
        : PostType.text;
    sent = json['sent'].toString();
    mention = json['mention'].toString();
    location = json['location'].toString();
  }

  set author(ChatUser author) {}

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uId'] = uId;
    data['pId'] = pId;
    data['title'] = title;
    data['link'] = link;
    data['type'] = type.name;
    data['sent'] = sent;
    data['mention'] = mention;
    data['location'] = location;
    return data;
  }


  /// chat gpt 
  Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    uId = data['uId'].toString();
    pId = doc.id;
    title = data['title'].toString();
    link = data['link'].toString();
    type = data['type'].toString() == PostType.image.name
        ? PostType.image
        : PostType.text;
    sent = data['sent'].toString();
    mention = data['mention'].toString();
    location = data['location'].toString();
  }




}

enum PostType { text, image }
