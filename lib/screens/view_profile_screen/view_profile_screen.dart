import 'package:bataao/api/apis.dart';
import 'package:bataao/models/chat_user.dart';
import 'package:bataao/models/connection_model.dart';
import 'package:bataao/screens/view_post_screen/view_post_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/post_model.dart';
import '../../theme/style.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key, required this.user});
  final ChatUser user;

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final String imgUrl = widget.user.images;

    List<Connection> clist = [];

    List<Post> posts = [];

    List<String> postId = [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  size: 28,
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.deblur_outlined,
                                  size: 28,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(imgUrl),
                            ),
                            SizedBox(
                              width: 200,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.user.name,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    widget.user.about,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  StreamBuilder(
                                      stream: APIs
                                          .getCurrentUserConnectionsAccepted(
                                              widget.user),
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
                                            clist = data
                                                    ?.map((e) =>
                                                        Connection.fromJson(
                                                            e.data()))
                                                    .toList() ??
                                                [];

                                            if (clist.isNotEmpty) {
                                              return ElevatedButton.icon(
                                                  style: ElevatedButton.styleFrom(
                                                      shape:
                                                          const StadiumBorder(),
                                                      backgroundColor:
                                                          Colors.white,
                                                      minimumSize: Size(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .5,
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .045)),
                                                  onPressed: () async {
                                                    await APIs.dropConnections(
                                                        widget.user);
                                                  },
                                                  icon: const Icon(
                                                    Icons.cut,
                                                    size: 26,
                                                    color: Colors.black,
                                                  ),
                                                  label: const Text(
                                                    "Disconnect Now",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                  ));
                                            } else {
                                              return ElevatedButton.icon(
                                                  style: ElevatedButton.styleFrom(
                                                      shape:
                                                          const StadiumBorder(),
                                                      backgroundColor: White,
                                                      minimumSize: Size(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .5,
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .045)),
                                                  onPressed: () async {
                                                    await APIs
                                                        .makeNewConnections(
                                                            widget.user);
                                                  },
                                                  icon: const Icon(
                                                    Icons.cut,
                                                    size: 26,
                                                    color: Colors.black,
                                                  ),
                                                  label: const Text(
                                                    "Connect Now",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                  ));
                                            }
                                        }
                                      }),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 8,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Background,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: APIs.getPostsByUser(widget.user.id),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          posts = snapshot.data!.docs
                              .map((doc) => Post.fromJson(
                                  doc.data() as Map<String, dynamic>))
                              .toList();

                          postId =
                              snapshot.data!.docs.map((e) => e.id).toList();
                        }

                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                          ),
                          itemCount: posts.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewPostScreen(
                                            post: posts[index],
                                            cuser: widget.user,
                                            postsId: postId[index],
                                          ))),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        image: NetworkImage(posts[index].link),
                                        fit: BoxFit.cover)),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
