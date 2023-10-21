// ignore_for_file: camel_case_types

import 'package:bataao/helper/dialogs.dart';
import 'package:bataao/screens/bookmark_post_screen.dart/bookmark_post_screen.dart';
import 'package:bataao/screens/edit_profile_screen/edit_profile_screen.dart';
import 'package:bataao/screens/my_profile_screen/my_profile_screen.dart';
import 'package:bataao/screens/notification_screen/notification_screen.dart';
import 'package:bataao/screens/status_screen/status_screen.dart';
import 'package:bataao/screens/welcome_screen/welcome_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../api/apis.dart';
import '../../models/chat_user.dart';
import '../../theme/style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});

  final ChatUser user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: primaryColor.withOpacity(.5),
                automaticallyImplyLeading: false,
                elevation: 0,
                title: Text(
                  "Bataao",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Body),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationScreen()));
                      },
                      icon: const Icon(
                        Icons.notification_important_outlined,
                        size: 24,
                        color: Body,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: IconButton(
                        onPressed: () {
                          // _showPostBottomShit();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      StatusScreen(user: APIs.selfInfo)));
                        },
                        icon: const Icon(
                          Icons.looks,
                          size: 24,
                          color: Body,
                        )),
                  )
                ],
              ),
            ];
          },
          body: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                  gradient: BG_Gradient,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * .01),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyProfileScreen(user: widget.user))),
                      child: Container(
                        decoration: BoxDecoration(             
            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  width: 65,
                                  height: 65,
                                  imageUrl: widget.user.images,
                                  fit: BoxFit.fill,
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.user.name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    widget.user.about,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black45),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    _profileItemCard(
                        icon: const Icon(
                          Icons.edit,
                          size: 26,
                          color: IconCol,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      EditProfileScreen(user: APIs.selfInfo)));
                        },
                        title: "Edit"),
                    const SizedBox(
                      height: 10,
                    ),
                    _profileItemCard(
                        icon: const Icon(
                          Icons.bookmark,
                          size: 26,
                          color: IconCol,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      BookmarkPostScreen(users: widget.user)));
                        },
                        title: "Bookmark"),
                    const SizedBox(
                      height: 10,
                    ),
                    _profileItemCard(
                        icon: const Icon(
                          Icons.document_scanner_outlined,
                          size: 26,
                          color: IconCol,
                        ),
                        onTap: () {},
                        title: "Documentation"),
                    const SizedBox(
                      height: 10,
                    ),
                    _profileItemCard(
                        icon: const Icon(
                          Icons.new_releases_outlined,
                          size: 26,
                          color: IconCol,
                        ),
                        onTap: () {},
                        title: "What's New"),
                    const SizedBox(
                      height: 10,
                    ),
                    _profileItemCard(
                        icon: const Icon(
                          Icons.settings_outlined,
                          size: 26,
                          color: IconCol,
                        ),
                        onTap: () {},
                        title: "Settings"),
                    const SizedBox(
                      height: 10,
                    ),
                    _profileItemCard(
                        icon: const Icon(
                          Icons.logout_outlined,
                          size: 26,
                          color: IconCol,
                        ),
                        onTap: () async {
                          // update logout status in firebase ..
                          APIs.updateActiveStatus(false);

                          // For showing progress bar ...
                          MyProgressBars.showProgressBar(context);
                          // Sign Out from app ...
                          await APIs.auth.signOut().then((value) async {
                            await GoogleSignIn().signOut().then((value) {
                              // For hideing progress ...
                              Navigator.pop(context);

                              APIs.auth = FirebaseAuth.instance;
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const WelcomeScreen()));
                            });
                          });
                        },
                        title: "Log Out")
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class _profileItemCard extends StatelessWidget {
  final Icon icon;
  final String title;
  final VoidCallback onTap;

  const _profileItemCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            // color: Colors.grey.shade100,
         
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              icon,
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500, color: IconCol),
              )
            ],
          ),
        ),
      ),
    );
  }
}
