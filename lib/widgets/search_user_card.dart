import 'package:bataao/api/apis.dart';
import 'package:bataao/models/chat_user.dart';
import 'package:bataao/screens/chat_screen/chat_screen.dart';
import 'package:bataao/widgets/dialogs/profile_view.dart';
import 'package:flutter/material.dart';

import '../models/connection_model.dart';

class SearchUserCard extends StatefulWidget {
  final ChatUser user;
  const SearchUserCard({super.key, required this.user});

  @override
  State<SearchUserCard> createState() => _SearchUserCardState();
}

class _SearchUserCardState extends State<SearchUserCard> {
  List<Connection> _clist = [];
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // for navigaoiing chat screen .
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ChatScreen(user: widget.user)));
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => ProfileViewDialog(user: widget.user));
                    },
                    child: CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(widget.user.images),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.user.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Text(
                          widget.user.about,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder(
                      stream:
                          APIs.getCurrentUserConnectionsAccepted(widget.user),
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
                            _clist = data
                                    ?.map((e) => Connection.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (_clist.isNotEmpty) {
                              return OutlinedButton(
                                onPressed: () async {
                                  await APIs.dropConnections(widget.user);
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                    width: 2,
                                    color: Colors.blue,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text("Disconnect"),
                              );
                            } else {
                              return OutlinedButton(
                                onPressed: () async {
                                  await APIs.makeNewConnections(widget.user);
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                    width: 2,
                                    color: Colors.blue,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text("Connect"),
                              );
                            }
                        }
                      })
                ],
              ),
            ],
          ),
        ));
  }
}
