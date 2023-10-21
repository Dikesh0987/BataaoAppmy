import 'package:bataao/models/chat_user.dart';
import 'package:bataao/screens/view_profile_screen/view_profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../theme/style.dart';

class ProfileViewDialog extends StatelessWidget {
  const ProfileViewDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: SizedBox(
        width: 250,
        height: 300,
        child: Stack(
          children: [
            Positioned(
              top: 5,
              left: 5,
              right: 5,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    width: 280,
                    height: 250,
                    fit: BoxFit.cover,
                    imageUrl: user.images,
                    // placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 260,
              left: 10,
              width: 200,
              child: Text(
                user.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14, color: Body),
              ),
            ),
            Positioned(
              top: 278,
              left: 10,
              width: 200,
              child: Text(
                user.about,
                maxLines: 1,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14, color: Body),
              ),
            ),
            Positioned(
                right: -5,
                bottom: -5,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    ViewProfileScreen(user: user)));
                      },
                      icon: const Icon(
                        Icons.info_outline,
                        size: 26,
                        color: Sky_Blue,
                      )),
                )),
          ],
        ),
      ),
    );
  }
}
