import 'package:bataao/api/apis.dart';
import 'package:bataao/helper/my_date_util.dart';
import 'package:bataao/models/chat_user.dart';
import 'package:bataao/models/message.dart';
import 'package:bataao/screens/chat_screen/chat_screen.dart';
import 'package:bataao/widgets/dialogs/profile_view.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  // last message info
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // for navigaoiing chat screen .
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ChatScreen(user: widget.user)));
        },
        child: StreamBuilder(
          stream: APIs.getLastMessages(widget.user),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(
                  child: CircularProgressIndicator(),
                );

              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;

                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList();
                // if (list != null) {
                //   _message = list[0];
                // }
                if (list!.isNotEmpty) _message = list[0];
                return Padding(
                  padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) =>
                                        ProfileViewDialog(user: widget.user));
                              },
                              child: CircleAvatar(
                                  radius: (25),
                                  backgroundColor: Colors.white,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(28),
                                    child: Image.network(
                                      widget.user.images,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .cumulativeBytesLoaded
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                                  ))),
                          const SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.user.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: Text(
                                  _message != null
                                      ? _message!.type == Type.image
                                          ? 'Image'
                                          : _message!.msg
                                      : widget.user.about,
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
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            _message != null
                                ? myDateUtil.getLastMessagesTime(
                                    context: context, time: _message!.sent)
                                : "Say Hii !",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          _message != null
                              ? _message!.read.isEmpty &&
                                      _message!.fromId != APIs.user.uid
                                  ? Container(
                                      width: 40.0,
                                      height: 20.0,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'NEW',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : _message!.read.isEmpty &&
                                          _message!.toId != APIs.user.uid
                                      ? const Icon(
                                          Icons.done_all_outlined,
                                          color: Colors.grey,
                                        )
                                      : const Icon(
                                          Icons.done_all_outlined,
                                          color: Colors.blue,
                                        )
                              : const Text("🤔")
                        ],
                      ),
                    ],
                  ),
                );
            }
          },
        ));
  }
}
