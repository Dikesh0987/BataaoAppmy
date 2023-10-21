// ignore_for_file: non_constant_identifier_names

import 'package:bataao/models/bookmark_post.dart';
import 'package:bataao/models/connection_model.dart';
import 'package:bataao/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:bataao/models/chat_user.dart';
import 'package:bataao/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/comment_model.dart';
import '../models/like_unlike_post_model.dart';
import '../models/status_model.dart';

class APIs {
  // for authantication ..
  static FirebaseAuth auth = FirebaseAuth.instance;

  // cloudfirestore Accress ....
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // cloude storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // cloud message
  static FirebaseMessaging fmessaging = FirebaseMessaging.instance;

  //for getting firbase messageing tocken
  static Future<void> getFirebaseMessagingToken() async {
    await fmessaging.requestPermission();
    await fmessaging.getToken().then((t) {
      if (t != null) {
        selfInfo.pushToken = t;
       debugPrint('Push Token : $t');
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint(
            'Message also contained a notification: ${message.notification}');
      }
    });
  }

  static Future<void> sendPushNotifications(
      ChatUser chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": selfInfo.name,
          "body": msg,
          "android_channel_id": "chats"
        },
        "data": {
          "some_data": "User Id : ${selfInfo.id}",
        },
      };
      var response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'key=AAAAp6uIMyY:APA91bGFYnDE0ZuWbqJPUJ3uFP6Dgo6THmSzAGXQ4tT3E86uvDUNAml0_Mwcsi6jJvuFIYtQFCdYAR8EgaqVOpUXKwu-bJ_PNmVoIIvuBfzaZm8xsdhAZ5PFPFi-lbOt0xawBemBbEpU'
              },
              body: jsonEncode(body));
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
    } catch (e) {
      debugPrint("\nsendPushNotifications : $e");
    }
  }

  // for storeing current user info in  ..
  static late ChatUser selfInfo;
  static late ChatUser myinfo;

  // return current user
  static User get user => auth.currentUser!;

  //for checking user data exist or not in firestore database ...
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // for create a new connection id ..
  static String getConnectionID(String id) {
    return user.uid.hashCode <= id.hashCode
        ? '${user.uid}_$id'
        : '${id}_${user.uid}';
  }

  // for create a new connection id ..
  static String findConnectionID(String id) {
    return user.uid.hashCode <= id.hashCode
        ? '${user.uid}_$id'
        : '${id}_${user.uid}';
  }

  // get all notifications
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllConnections(
      ChatUser user) {
    return APIs.firestore
        .collection('connections/${getConnectionID(user.id)}/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // Already connection is exist in data base than ..

  static Future<bool> connectionExists(ChatUser user) async {
    return (await firestore
            .collection('connections/')
            .doc(getConnectionID(user.id))
            .get())
        .exists;
  }

  // Get connection users data

  static Stream<QuerySnapshot<Map<String, dynamic>>> getConnectionsUsersData(
      List<Connection> userId) {
    return firestore
        .collection('users')
        .where('id', whereIn: userId.map((e) => e.fromId))
        // .where('id', isNotEqualTo: APIs.user.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getConnectionsUsersDataFrom(List<Connection> userId) {
    return firestore
        .collection('users')
        .where('id', whereIn: userId.map((e) => e.fromId))
        // .where('id', isNotEqualTo: APIs.user.uid)
        .snapshots();
  }

  // Get All connections notifications

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getCurrentUserAllConnections() {
    return APIs.firestore
        .collection('connections')
        .where('toId', isEqualTo: APIs.selfInfo.id)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  // Get one user connections accepted
  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getCurrentUserConnectionsAccepted(ChatUser user) {
    return APIs.firestore
        .collection('connections')
        .where('connectionId', isEqualTo: getConnectionID(user.id))
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsersConn() {
    return APIs.firestore
        .collection('users')
        .doc(APIs.user.uid)
        .collection('list')
        .where('status', isEqualTo: 'accept')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getSalectedUserData(
      List<String> sId) {
    return APIs.firestore
        .collection('users')
        .where('id', whereIn: sId)
        .snapshots();
  }

  // for make connection functions ..
  static Future<void> makeNewConnections(ChatUser user) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final connection = Connection(
      connectionId: getConnectionID(user.id),
      fromId: APIs.selfInfo.id,
      toId: user.id,
      status: 'pending',
      sent: time,
    );

    // Check connections exist or not :
    firestore
        .collection('connections')
        .doc(getConnectionID(user.id))
        .set(connection.toJson())
        .then((value) =>
            sendPushNotifications(user, "Want Connection With You."));
  }

  // Assuming 'uId' is the ID of the user whose posts are to be fetched
  static Stream<QuerySnapshot<Map<String, dynamic>>> getPostsByUser(
      String uId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('uId', isEqualTo: uId)
        .snapshots();
  }

  // for make connection functions ..
  static Future<void> dropConnections(ChatUser user) async {
    firestore.collection('connections').doc(getConnectionID(user.id)).delete();
    firestore
        .collection('users')
        .doc(APIs.user.uid)
        .collection('list')
        .doc(user.id)
        .delete();
    firestore
        .collection('users')
        .doc(user.id)
        .collection('list')
        .doc(APIs.user.uid)
        .delete();
  }

  // for upadeting connections status and time
  static Future<void> updateConnections(ChatUser user) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    await firestore
        .collection('connections')
        .doc(getConnectionID(user.id))
        .update({
      'status': 'accept',
    });

    final connection = Connection(
      connectionId: getConnectionID(user.id),
      fromId: APIs.selfInfo.id,
      toId: user.id,
      status: 'accept',
      sent: time,
    );
    firestore
        .collection('users')
        .doc(APIs.selfInfo.id)
        .collection('list')
        .doc(user.id)
        .set(connection.toJson());
    firestore
        .collection('users')
        .doc(user.id)
        .collection('list')
        .doc(APIs.selfInfo.id)
        .set(connection.toJson());
  }

  // get current user info
  static Future<void> getCurrentUserInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        selfInfo = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();
        APIs.updateActiveStatus(true);
      } else {
        await createUser().then((value) => getCurrentUserInfo());
      }
    });
  }

  // for create new user data and store data ...
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        images: user.photoURL.toString(),
        name: user.displayName.toString(),
        about: "Hey , I'm Useing Bataao...",
        createdAt: time,
        id: user.uid,
        lastActive: time,
        isOnline: true,
        pushToken: '',
        email: user.email.toString());

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // get all user for static function\sd

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return APIs.firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllStatusUsers() {
    return APIs.firestore
        .collection('users')
        .doc(APIs.selfInfo.id)
        .collection('list')
        .snapshots();
  }
  // Update current user data

  static Future<void> updateUserInfo() async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'name': selfInfo.name, 'about': selfInfo.about});
  }

  // geting spasafic user
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return APIs.firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // update online status and last seen ..
  static Future<void> updateActiveStatus(bool isOnline) async {
    APIs.firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': selfInfo.pushToken,
    });
  }

  // Upload profile pictures ..

  static Future<void> uploadProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {});

    // update data
    selfInfo.images = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'images': selfInfo.images});
  }

  // get all posts
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllPosts() {
    return APIs.firestore.collection('posts').snapshots();
  }

  // get all status
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUserStatus(
      ChatUser user) {
    return APIs.firestore
        .collection('status/${user.id}/list')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // for sending status ..
  static Future<void> uploadStatusData(
      ChatUser chatUser, String title, String urlLink, StatusType type) async {
    //sent time
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // make status
    final Status status = Status(
      uId: chatUser.id,
      title: title,
      link: urlLink,
      type: type,
      sent: time,
    );

    final ref = firestore.collection('status/${user.uid}/list');
    await ref.doc(time).set(status.toJson());
  }

  // Upload status pictue..
  static Future<void> uploadStatusPicture(
      ChatUser chatUser, String title, File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child(
        'status/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {});

    // upload data
    final link = await ref.getDownloadURL();
    await uploadStatusData(chatUser, title, link, StatusType.image);
  }

  /// for upllad post and data in inyterrnaetj dfbkdfjbgvyuf

  // for uploading post ..
  static Future<void> uploadPostData(ChatUser chatUser, String mention,
      String title, String urlLink, PostType type, String location) async {
    //sent time
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // make status
    final Post post = Post(
        uId: chatUser.id,
        pId: chatUser.id,
        title: title,
        link: urlLink,
        type: type,
        sent: time,
        mention: mention,
        location: location);

    final ref = firestore.collection('posts');
    await ref.doc().set(post.toJson());
  }

  // Upload status pictue..
  static Future<void> uploadPostPicture(ChatUser chatUser, String mention,
      String title, String location, File file) async {
    final ext = file.path.split('.').last;

    final ref = storage.ref().child(
        'posts/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {});

    // upload data
    final link = await ref.getDownloadURL();
    await uploadPostData(
        chatUser, mention, title, link, PostType.image, location);
  }

  // ======= Chat ======== ///
  // chats (collections) --> conversation_id(doc) --> messages (collection ) --> msg (doc)
  // for getting conversation id
  static String getConversationID(String id) {
    return user.uid.hashCode <= id.hashCode
        ? '${user.uid}_$id'
        : '${id}_${user.uid}';
  }

  // get all msg form database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return APIs.firestore
        .collection('chats/${getConversationID(user.id)}/messages')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // for sending messages ..

  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    //sent time
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // make msg
    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: "",
        type: type,
        sent: time,
        fromId: user.uid);

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotifications(chatUser, type == Type.text ? msg : 'image'));
  }

  // Update read time and date..
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // Get Last message of a one to one chat ..
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      ChatUser user) {
    return APIs.firestore
        .collection('chats/${getConversationID(user.id)}/messages')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  // send image cgat..
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {});

    // update data
    final imageUrl = await ref.getDownloadURL();
    await APIs.sendMessage(chatUser, imageUrl, Type.image);
  }

  // delete message ..
  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  // Update message.
  static Future<void> updateMessage(
      Message message, String updatedMessage) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMessage});
  }

  // static connectionId(ChatUser user) {}

  // ---- For like --- ///

  // Store Like data in firestore
  static Future<void> LikeData(Post post, String postsId) async {
    //sent time
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // make status
    final LikeUnlike likeunlike = LikeUnlike(
      pId: postsId,
      likeUnlike: true,
      sent: time,
    );

    final ref = firestore.collection('posts').doc(postsId).collection('list');
    await ref.doc(APIs.selfInfo.id).set(likeunlike.toJson());
  }

  // Store unlike data

  static Future<void> UnlikeData(
      ChatUser chatUser, Post post, String postsId) async {
    //sent time

    final ref = firestore.collection('posts').doc(postsId).collection('list');
    await ref.doc(APIs.selfInfo.id).delete();
  }

  // check likeed user exist or not
  static Future<bool> LikeUserExists(String postsId) async {
    return (await firestore
            .collection('posts')
            .doc(postsId)
            .collection('list')
            .doc(APIs.selfInfo.id)
            .get())
        .exists;
  }

  // get all msg form database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllLikes(
      String postId) {
    return APIs.firestore
        .collection('posts/$postId/list')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // ---- For Comments --- ///

  // Store Like data in firestore
  static Future<void> MakeComment(
      Post post, String postsId, String commentText) async {
    //sent time
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // make status
    final Comments comments = Comments(
      pId: postsId,
      uId: APIs.selfInfo.id,
      comment: commentText,
      sent: time,
    );

    final ref =
        firestore.collection('posts').doc(postsId).collection('comments');
    await ref.doc(APIs.selfInfo.id).set(comments.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllComments(
      String postId) {
    return APIs.firestore
        .collection('posts/$postId/comments')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // --- Bookmark Posts --- ////

  // Add book markmin
  static Future<void> makeBookmark(String postsId) async {
    //sent time
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // make status
    final Bookmark bookmark = Bookmark(
      pId: postsId,
      sent: time,
    );

    final ref = firestore
        .collection('bookmark')
        .doc(APIs.selfInfo.id)
        .collection('list');
    await ref.doc(postsId).set(bookmark.toJson());
  }

  // bookmark exist
  static Future<bool> BookmarkExists(String postsId) async {
    return (await firestore
            .collection('bookmark')
            .doc(APIs.selfInfo.id)
            .collection('list')
            .doc(postsId)
            .get())
        .exists;
  }

  // delete bookmark
  static Future<void> BookmarkDelete(String postsId) async {
    final ref = firestore
        .collection('bookmark')
        .doc(APIs.selfInfo.id)
        .collection('list');
    await ref.doc(postsId).delete();
  }

  // show bookmark data in files //

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllBookMark(
      ChatUser user) {
    return APIs.firestore
        .collection('bookmark/${user.id}/list')
        .orderBy('sent', descending: true)
        .snapshots();
  }
}
