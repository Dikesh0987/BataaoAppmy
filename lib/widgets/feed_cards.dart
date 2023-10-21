import 'package:bataao/api/apis.dart';
import 'package:bataao/helper/my_date_util.dart';
import 'package:bataao/models/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../screens/view_post_screen/view_post_screen.dart';
import '../screens/view_profile_screen/view_profile_screen.dart';
import '../theme/style.dart';

class FeedCards extends StatefulWidget {
  const FeedCards({
    super.key,
    required this.post,
    required this.cuser,
    required this.users,
    required this.postsId,
  });

  final Post post;
  final String postsId;
  final ChatUser cuser;
  final ChatUser users;

  @override
  State<FeedCards> createState() => _FeedCardsState();
}

class _FeedCardsState extends State<FeedCards> {
  bool _buttonPressed = false;
  bool _bookmarkPressed = false;
  int _collectionLength = 0;
  int _commentLength = 0;

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
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 2, right: 2),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ViewProfileScreen(user: widget.cuser)));
                    },
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
                              image: NetworkImage(widget.cuser.images),
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
                          context: context, time: widget.post.sent)),
                      trailing: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ViewProfileScreen(user: widget.cuser)));
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            width: 1,
                            color: Colors.blue,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("view"),
                      ),
                    ),
                  ),
                  InkWell(
                    onDoubleTap: () => debugPrint('Like post'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ViewPostScreen(
                                  post: widget.post,
                                  cuser: widget.cuser,
                                  postsId: widget.postsId,
                                )),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(0.0),
                      width: double.infinity,
                      height: 400.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(115, 235, 231, 231),
                            offset: Offset(0, 5),
                            blurRadius: 8.0,
                          ),
                        ],
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(widget.post.link),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(children: [
                        Positioned(
                            bottom: 5,
                            right: 15,
                            child: Text(
                              "Location : ${widget.post.location}",
                              style: TextStyle(
                                  color: White.withOpacity(.8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ))
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                                        ? APIs.UnlikeData(APIs.selfInfo,
                                                widget.post, widget.postsId)
                                            .then((value) {
                                            setState(() {
                                              _buttonPressed = !_buttonPressed;
                                            });
                                          })
                                        : APIs.LikeData(
                                                widget.post, widget.postsId)
                                            .then((value) {
                                            APIs.sendPushNotifications(
                                                widget.cuser,
                                                "Like Your Post ❤️ ");
                                            setState(() {
                                              _buttonPressed = !_buttonPressed;
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
                                    _showCommentDialog();
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
                                  ? await APIs.BookmarkDelete(widget.postsId)
                                  : await APIs.makeBookmark(widget.postsId);
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
    );
  }

  // for make a comment
  void _showCommentDialog() {
    String makeComment = "";
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon(
                    //   Icons.message,
                    //   size: 26,
                    //   color: Colors.black,
                    // ),
                    Text(
                      "Comment",
                      style: TextStyle(color: Colors.black),
                    )
                  ]),

              // content
              content: TextFormField(
                initialValue: "",
                maxLines: null,
                onChanged: (value) => makeComment = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    APIs.MakeComment(widget.post, widget.postsId, makeComment)
                        .then((value) => APIs.sendPushNotifications(
                            widget.cuser, "Comment : $makeComment"));
                  },
                  child: const Text(
                    "Go",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ));
  }
}
