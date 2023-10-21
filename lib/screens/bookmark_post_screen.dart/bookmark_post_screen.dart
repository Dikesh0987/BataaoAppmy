import 'package:bataao/api/apis.dart';
import 'package:bataao/models/chat_user.dart';
import 'package:bataao/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../theme/style.dart';

class BookmarkPostScreen extends StatefulWidget {
  const BookmarkPostScreen({super.key, required this.users});

  final ChatUser users;

  @override
  State<BookmarkPostScreen> createState() => _BookmarkPostScreenState();
}

class _BookmarkPostScreenState extends State<BookmarkPostScreen> {
  List<String> _pIdlist = [];
  List<ChatUser> pUsers = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(color: primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.clear,
                            size: 24,
                          )),
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          "Bookmark",
                          style: TextStyle(
                              fontSize: 16,
                              color: Body,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              )),
          Expanded(
              flex: 12,
              child: Container(
                decoration: const BoxDecoration(
                    gradient: BG_Gradient,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                      stream: APIs.getAllBookMark(widget.users),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          // if data has been loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(
                                child: CircularProgressIndicator());

                          // data lodede

                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            _pIdlist = data?.map((e) => e.id).toList() ?? [];
                            debugPrint('$_pIdlist');

                            if (_pIdlist.isNotEmpty) {
                              return StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('posts')
                                    .where(FieldPath.documentId,
                                        whereIn: _pIdlist)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text('Something went wrong');
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  final posts = snapshot.data!.docs
                                      .map((doc) => Post.fromJson(
                                          doc.data()! as Map<String, dynamic>))
                                      .toList();

                                  final postsId = posts
                                      .map(
                                        (e) => e.uId,
                                      )
                                      .toList();

                                  return GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                    ),
                                    itemCount: _pIdlist.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('users')
                                            .where(FieldPath.documentId,
                                                whereIn: postsId)
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          if (snapshot.hasError) {
                                            return const Text(
                                                'Something went wrong');
                                          }

                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }

                                          final post = posts[index];

                                          return InkWell(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          post.link.toString()),
                                                      fit: BoxFit.cover)),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  "(No bookmark found)",
                                  style: TextStyle(fontSize: 20, color: Body),
                                ),
                              );
                            }
                        }
                      }),
                ),
              ))
        ],
      )),
    );
  }
}
