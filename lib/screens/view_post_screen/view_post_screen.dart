// ignore_for_file: library_private_types_in_public_api

import 'package:bataao/helper/my_date_util.dart';
import 'package:bataao/widgets/comment_card.dart';
import 'package:bataao/widgets/like_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../api/apis.dart';
import '../../models/chat_user.dart';
import '../../models/comment_model.dart';
import '../../models/post_model.dart';
import '../../theme/style.dart';

class ViewPostScreen extends StatefulWidget {
  const ViewPostScreen(
      {super.key,
      required this.post,
      required this.cuser,
      required this.postsId});
  final Post post;
  final ChatUser cuser;
  final String postsId;

  @override
  _ViewPostScreenState createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {
  bool _buttonPressed = false;
  bool _bookmarkPressed = false;
  bool _likecomment = false;
  int _collectionLength = 0;
  int _commentLength = 0;
  List<ChatUser> _list = [];
  List<String> _likeList = [];
  List<String> _commentList = [];
  List<Comments> _comments = [];

  @override
  void initState() {
    super.initState();
    checkData();
  }

  Future<void> checkData() async {
    if (await APIs.LikeUserExists(widget.postsId)) {
      setState(() {
        _buttonPressed = true;
      });
    } else {
      setState(() {
        _buttonPressed = false;
      });
    }

    // for book mark
    if (await APIs.BookmarkExists(widget.postsId)) {
      setState(() {
        _bookmarkPressed = true;
      });
    } else {
      setState(() {
        _bookmarkPressed = false;
      });
    }

    // for like list
    APIs.firestore
        .collection('posts')
        .doc(widget.postsId)
        .collection('list')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        _collectionLength = querySnapshot.size;
      });
    });
// for comment list
    APIs.firestore
        .collection('posts')
        .doc(widget.postsId)
        .collection('comments')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        _commentLength = querySnapshot.size;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF0F6),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 5.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: ListTile(
                                  leading: Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black45,
                                          offset: Offset(0, 2),
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      child: ClipOval(
                                        child: Image(
                                          height: 50.0,
                                          width: 50.0,
                                          image:
                                              NetworkImage(widget.cuser.images),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    widget.cuser.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(myDateUtil.getFormattedTime(
                                      context: context,
                                      time: widget.post.sent)),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.clear,
                                    size: 30,
                                  ))
                            ],
                          ),
                          InkWell(
                            onDoubleTap: () => debugPrint('Like post'),
                            child: Container(
                              margin: const EdgeInsets.all(10.0),
                              width: double.infinity,
                              height: 400.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black45,
                                    offset: Offset(0, 5),
                                    blurRadius: 8.0,
                                  ),
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(widget.post.link),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(
                                            _buttonPressed
                                                ? Icons.favorite_outlined
                                                : Icons.favorite_border,
                                            color: _buttonPressed
                                                ? Colors.red
                                                : Colors.black,
                                          ),
                                          iconSize: 30.0,
                                          onPressed: () async {
                                            _buttonPressed
                                                ? APIs.UnlikeData(
                                                        APIs.selfInfo,
                                                        widget.post,
                                                        widget.postsId)
                                                    .then((value) {
                                                    setState(() {
                                                      _buttonPressed =
                                                          !_buttonPressed;
                                                    });
                                                  })
                                                : APIs.LikeData(widget.post,
                                                        widget.postsId)
                                                    .then((value) {
                                                    setState(() {
                                                      _buttonPressed =
                                                          !_buttonPressed;
                                                    });
                                                  });
                                          },
                                        ),
                                        Text(
                                          _collectionLength.toString(),
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 20.0),
                                    Row(
                                      children: <Widget>[
                                        IconButton(
                                          icon: const Icon(Icons.chat_outlined),
                                          iconSize: 30.0,
                                          onPressed: () {
                                            setState(() {
                                              _likecomment = !_likecomment;
                                            });
                                          },
                                        ),
                                        Text(
                                          _commentLength.toString(),
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                IconButton(
                                    icon: Icon(_bookmarkPressed
                                        ? Icons.bookmark_added
                                        : Icons.bookmark_add_outlined),
                                    iconSize: 30.0,
                                    onPressed: () async {
                                      _bookmarkPressed
                                          ? await APIs.BookmarkDelete(
                                              widget.postsId)
                                          : await APIs.makeBookmark(
                                              widget.postsId);
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              _likecomment
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                          height: MediaQuery.of(context).size.height * .95,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0)),
                          ),
                          child: Column(
                            children: [
                              _chatInput(),
                              Expanded(
                                child: StreamBuilder(
                                  stream: APIs.getAllComments(widget.postsId),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      // if data has been loading
                                      case ConnectionState.waiting:
                                      case ConnectionState.none:
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );

                                      // data lodede

                                      case ConnectionState.active:
                                      case ConnectionState.done:
                                        final data = snapshot.data?.docs;
                                        _commentList =
                                            data?.map((e) => e.id).toList() ??
                                                [];

                                        _comments = data
                                                ?.map((e) =>
                                                    Comments.fromJson(
                                                        e.data()))
                                                .toList() ??
                                            [];

                                        debugPrint("$_commentList");

                                        if (_commentList.isNotEmpty) {
                                          return StreamBuilder(
                                            stream: APIs.getSalectedUserData(
                                                _commentList),
                                            builder: (context, snapshot) {
                                              switch (
                                                  snapshot.connectionState) {
                                                // if data has been loading
                                                case ConnectionState.waiting:
                                                case ConnectionState.none:
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );

                                                // data lodede

                                                case ConnectionState.active:
                                                case ConnectionState.done:
                                                  final data =
                                                      snapshot.data?.docs;
                                                  _list = data
                                                          ?.map((e) => ChatUser
                                                              .fromJson(
                                                                  e.data()))
                                                          .toList() ??
                                                      [];

                                                  if (_list.isNotEmpty) {
                                                    return ListView.builder(
                                                        itemCount:
                                                            _list.length,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 5),
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        itemBuilder:
                                                            (context, index) {
                                                          return CommentCard(
                                                            user:
                                                                _list[index],
                                                            comments:
                                                                _comments[
                                                                    index],
                                                          );
                                                        });
                                                  } else {
                                                    return const Center(
                                                      child: Text(
                                                        "No Data Found",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    );
                                                  }
                                              }
                                            },
                                          );
                                        } else {
                                          return Align(
                                            alignment: Alignment.topCenter,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 50),
                                              child: ElevatedButton.icon(
                                                  style: ElevatedButton.styleFrom(
                                                      shape:
                                                          const StadiumBorder(),
                                                      backgroundColor:
                                                          Colors.white,
                                                      minimumSize: Size(
                                                          MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .5,
                                                          MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              .06)),
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.comment_bank,
                                                    size: 28,
                                                    color: Body,
                                                  ),
                                                  label: const Text(
                                                    "No Comments",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  )),
                                            ),
                                          );
                                        }
                                    }
                                  },
                                ),
                              ),
                            ],
                          )),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                          height: MediaQuery.of(context).size.height * .95,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0)),
                          ),
                          child: StreamBuilder(
                            stream: APIs.getAllLikes(widget.postsId),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                // if data has been loading
                                case ConnectionState.waiting:
                                case ConnectionState.none:
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );

                                // data lodede

                                case ConnectionState.active:
                                case ConnectionState.done:
                                  final data = snapshot.data?.docs;
                                  _likeList =
                                      data?.map((e) => e.id).toList() ?? [];

                                  debugPrint("$_likeList");

                                  if (_likeList.isNotEmpty) {
                                    return StreamBuilder(
                                      stream:
                                          APIs.getSalectedUserData(_likeList),
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          // if data has been loading
                                          case ConnectionState.waiting:
                                          case ConnectionState.none:
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );

                                          // data lodede

                                          case ConnectionState.active:
                                          case ConnectionState.done:
                                            final data = snapshot.data?.docs;
                                            _list = data
                                                    ?.map((e) =>
                                                        ChatUser.fromJson(
                                                            e.data()))
                                                    .toList() ??
                                                [];

                                            if (_list.isNotEmpty) {
                                              return ListView.builder(
                                                  itemCount: _list.length,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return LikeCard(
                                                        user: _list[index]);
                                                  });
                                            } else {
                                              return const Center(
                                                child: Text(
                                                  "No Data Found",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              );
                                            }
                                        }
                                      },
                                    );
                                  } else {
                                    return Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 50),
                                        child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                                shape: const StadiumBorder(),
                                                backgroundColor: Colors.white,
                                                minimumSize: Size(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        .5,
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        .06)),
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.add_reaction_outlined,
                                              size: 28,
                                              color: Body,
                                            ),
                                            label: const Text(
                                              "No Like ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            )),
                                      ),
                                    );
                                  }
                              }
                            },
                          )),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chatInput() {
    String makeComment = "";
    final TextEditingController commentText = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                child: TextFormField(
              controller: commentText,
              maxLines: null,
              onChanged: (value) => makeComment = value,
              decoration: InputDecoration(
              hintText: "Make Your Comments...",
              hintStyle: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20))),
            )),
            // Send button
            MaterialButton(
                minWidth: 0,
                onPressed: () {
                  APIs.MakeComment(widget.post, widget.postsId, makeComment);
                  commentText.clear();
                },
                color: Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.only(
                    top: 10, right: 5, left: 10, bottom: 10),
                child: const Icon(
                  Icons.send,
                  size: 28,
                  color: PrimaryBlue,
                ))
          ],
        ),
      ),
    );
  }
}
