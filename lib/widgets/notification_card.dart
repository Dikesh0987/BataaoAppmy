import 'package:bataao/api/apis.dart';
import 'package:bataao/models/chat_user.dart';
import 'package:bataao/theme/style.dart';
import 'package:flutter/material.dart';

import 'dialogs/profile_view.dart';

class CustomFollowNotifcation extends StatefulWidget {
  const CustomFollowNotifcation({Key? key, required this.user})
      : super(key: key);

  final ChatUser user;

  @override
  State<CustomFollowNotifcation> createState() =>
      _CustomFollowNotifcationState();
}

class _CustomFollowNotifcationState extends State<CustomFollowNotifcation> {
  bool follow = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            color: White, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => ProfileViewDialog(user: widget.user));
                    },
                    child: CircleAvatar(
                      radius: 30.0,
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
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Text(
                          widget.user.about,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.white,
                      minimumSize: Size(MediaQuery.of(context).size.width * .1,
                          MediaQuery.of(context).size.height * .05)),
                  onPressed: () async {
                    await APIs.updateConnections(widget.user);
                  },
                  child: const Text(
                    "Accept",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
