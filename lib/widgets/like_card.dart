import 'package:bataao/models/chat_user.dart';
import 'package:bataao/screens/view_profile_screen/view_profile_screen.dart';
import 'package:flutter/material.dart';

import 'dialogs/profile_view.dart';

class LikeCard extends StatefulWidget {
  const LikeCard({super.key, required this.user});
  final ChatUser user;
  @override
  State<LikeCard> createState() => _LikeCardState();
}

class _LikeCardState extends State<LikeCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
          child: InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) => ProfileViewDialog(user: widget.user));
            },
            child: CircleAvatar(
              child: ClipOval(
                child: Image(
                  height: 50.0,
                  width: 50.0,
                  image: NetworkImage(widget.user.images),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        title: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ViewProfileScreen(user: widget.user)));
          },
          child: Text(
            widget.user.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ViewProfileScreen(user: widget.user)));
            },
            child: Text(widget.user.about)),
        trailing: IconButton(
          icon: const Icon(
            Icons.favorite,
          ),
          color: Colors.red,
          onPressed: () => debugPrint('Like comment'),
        ),
      ),
    );
  }
}
