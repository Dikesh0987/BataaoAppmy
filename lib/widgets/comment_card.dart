import 'package:bataao/models/chat_user.dart';
import 'package:bataao/models/comment_model.dart';
import 'package:bataao/theme/style.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({super.key, required this.user, required this.comments});
  final ChatUser user;
  final Comments comments;
  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
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
          child: CircleAvatar(
            backgroundColor: Stroke,
            child: ClipOval(
              child: Image(
                height: 45.0,
                width: 45.0,
                image: NetworkImage(widget.user.images),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          widget.user.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(widget.comments.comment),
        trailing: IconButton(
          icon: const Icon(
            Icons.comment_bank_outlined,
          ),
          color: Body,
          onPressed: () => debugPrint('Like comment'),
        ),
      ),
    );
  }
}
