// ignore_for_file: library_private_types_in_public_api

import 'package:bataao/api/apis.dart';
import 'package:bataao/models/chat_user.dart';
import 'package:bataao/screens/notification_screen/notification_screen.dart';
import 'package:bataao/screens/status_screen/status_screen.dart';
import 'package:bataao/theme/style.dart';
import 'package:bataao/widgets/feed_cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/post_model.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({
    super.key,
    required this.users,
  });

  final ChatUser users;

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  // for all users ..
  List<ChatUser> _list = [];

  // for searching values .. 
  final List<ChatUser> _searchList = [];

  // for searching status ..
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    // for searching status ..
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: primaryColor.withOpacity(.5),
                  automaticallyImplyLeading: false,
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _isSearching
                        ? TextField(
                             decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "SEARCH NAME OR EMAIL",
                          
                        ),
                        style:
                             TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5,),
                            autofocus: true,
                            onChanged: (val) {
                              _searchList.clear();
                              for (var i in _list) {
                                if (i.name
                                        .toLowerCase()
                                        .contains(val.toLowerCase()) ||
                                    i.email
                                        .toLowerCase()
                                        .contains(val.toLowerCase())) {
                                  _searchList.add(i);
                                }
                                setState(() {
                                  _searchList;
                                });
                              }
                            },
                          )
                        : const Text(
                            'Bataao',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Body),
                          ),
                  ),
                  elevation: 0,

                  actions: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _isSearching = !_isSearching;
                          });
                        },
                        icon: Icon(
                          _isSearching ? Icons.clear : Icons.search,
                          color: Body,
                          size: 24,
                        )),
                    if (_isSearching == false)
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationScreen()));
                          },
                          icon: const Icon(
                            Icons.notification_important_outlined,
                            size: 24,
                            color: Body,
                          )),
                    
                    if (_isSearching == false)
                      Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: IconButton(
                            onPressed: () {
                              // _showPostBottomShit();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StatusScreen(user: APIs.selfInfo)));
                            },
                            icon: const Icon(
                              Icons.looks,
                              size: 24,
                              color: Body,
                            )),
                      )
                  ],
                  // floating: true,
                  // expandedHeight: 60.0,
                  // forceElevated: innerBoxIsScrolled,
                ),
              ];
            },
            body: SafeArea(
                child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final posts = snapshot.data!.docs
                    .map((doc) =>
                        Post.fromJson(doc.data()! as Map<String, dynamic>))
                    .toList();

                final postsId = snapshot.data!.docs.map((e) => e.id).toList();

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final users = snapshot.data!.docs
                        .map((doc) => ChatUser.fromJson(
                            doc.data()! as Map<String, dynamic>))
                        .toList();

                    final Map<String, ChatUser> userMap = {
                      for (var user in users) user.id: user
                    };

                    return Container(
                      decoration: const BoxDecoration(
                          gradient: BG_Gradient,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final post = posts[index];
                          final user = userMap[post.uId];

                          return FeedCards(
                            post: post,
                            cuser: user!,
                            postsId: postsId[index],
                            users: widget.users,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ))));
  }
}
