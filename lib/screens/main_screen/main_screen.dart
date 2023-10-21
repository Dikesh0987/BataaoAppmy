// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'dart:io';
import 'package:bataao/screens/all_users_screen/all_users_screen.dart';
import 'package:bataao/screens/notification_screen/notification_screen.dart';
import 'package:bataao/screens/profile_screen/profile_screen.dart';
import 'package:bataao/screens/status_screen/status_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../api/apis.dart';
import '../../models/chat_user.dart';
import '../../theme/style.dart';
import '../../widgets/chat_user_card.dart';
import '../feed_screen/feed_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    APIs.getCurrentUserInfo();
    APIs.getAllUsers();

    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }
      return Future.value(message);
    });
  }

  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor.withOpacity(1),
      // floating action buttton
      floatingActionButton: _pageIndex == 0
          ? FloatingActionButton(
              materialTapTargetSize: MaterialTapTargetSize.padded,
              backgroundColor: White,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllUsersScreen()));
              },
              child: const Icon(
                Icons.search_rounded,
                size: 26,
                color: IconCol,
              ),
            )
          : null,

      // Main Body
      body: getSelectedPage(index: _pageIndex),

      // Bottom nav bar
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: primaryColor,
        buttonBackgroundColor: Colors.white,
        height: 60,
        items: const <Widget>[
          Icon(
            Icons.chat_outlined,
            size: 24,
            color: IconCol,
          ),
          Icon(Icons.fiber_manual_record_outlined, size: 24, color: IconCol),
          Icon(
            Icons.person_2_outlined,
            size: 24,
            color: IconCol,
          ),
        ],
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 200),
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }

  Widget getSelectedPage({required int index}) {
    Widget widget;
    switch (index) {
      case 0:
        widget = const _mainBody();
        break;

      case 1:
        widget = FeedScreen(
          users: APIs.selfInfo,
        );
        break;

      default:
        widget = ProfileScreen(
          user: APIs.selfInfo,
        );
        break;
    }
    return widget;
  }
}

// Main Body
class _mainBody extends StatefulWidget {
  const _mainBody();

  @override
  State<_mainBody> createState() => __mainBodyState();
}

class __mainBodyState extends State<_mainBody> {
  // for all users ..
  List<ChatUser> _list = [];

  // for all connections
  List<String> _connList = [];

  // for searching values ..
  final List<ChatUser> _searchList = [];

  // for searching status ..
  bool _isSearching = false;

  // loding
  bool _loading = false;

  // Form Key

  final _formKey = GlobalKey<FormState>();

  String? _image;

  // for some filsds text editing controller

  final _mentionTextController = TextEditingController();
  final _locationTextController = TextEditingController();
  final _titleTextController = TextEditingController();

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
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _isSearching
                    ? TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "SEARCH NAME OR EMAIL",
                          
                        ),
                        style:
                             TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5,),
                        autofocus: true,
                        onChanged: (val) {
                          _searchList.clear();
                          for (var i in _list) {
                            if (i.name
                                    .toLowerCase()
                                    .contains(val.toLowerCase()) ||
                                i.email
                                    .toLowerCase()
                                    .contains(val.toLowerCase())) {
                              _searchList.add(i);
                            }
                            setState(() {
                              _searchList;
                            });
                          }
                        },
                      )
                    : const Text(
                        'Bataao',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Body),
                      ),
              ),
              elevation: 0,
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: Icon(
                      _isSearching ? Icons.clear : Icons.search,
                      color: IconCol,
                      size: 24,
                    )),
                if (_isSearching == false)
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
                        color: IconCol,
                      )),
                if (_isSearching == false)
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: IconButton(
                        onPressed: () {
                          _showPostBottomShit();
                        },
                        icon: const Icon(
                          Icons.add_box_outlined,
                          size: 24,
                          color: IconCol,
                        )),
                  ),
                if (_isSearching == false)
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
                          color: IconCol,
                        )),
                  )
              ],
            ),
          ];
        },
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: Container(
                      decoration: const BoxDecoration(
                          gradient: BG_Gradient,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: StreamBuilder(
                        stream: APIs.getAllUsersConn(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            // if data is loading
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                              return const Center(
                                child: CircularProgressIndicator(),
                              );

                            // data loaded
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data?.docs;
                              _connList = data?.map((e) => e.id).toList() ?? [];

                              debugPrint("$_connList");

                              if (_connList.isNotEmpty) {
                                return StreamBuilder(
                                  stream: APIs.getSalectedUserData(_connList),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      // if data is loading
                                      case ConnectionState.waiting:
                                      case ConnectionState.none:
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );

                                      // data loaded
                                      case ConnectionState.active:
                                      case ConnectionState.done:
                                        final data = snapshot.data?.docs;
                                        _list = data
                                                ?.map((e) =>
                                                    ChatUser.fromJson(e.data()))
                                                .toList() ??
                                            [];

                                        if (_list.isNotEmpty) {
                                          return ListView.builder(
                                            itemCount: _isSearching
                                                ? _searchList.length
                                                : _list.length,
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return ChatUserCard(
                                                user: _isSearching
                                                    ? _searchList[index]
                                                    : _list[index],
                                              );
                                            },
                                          );
                                        } else {
                                          return const Center(
                                            child: Text(
                                              "No Data Found",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          );
                                        }
                                    }
                                  },
                                );
                              } else {
                                return Center(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      backgroundColor: Colors.white,
                                      minimumSize: Size(
                                        MediaQuery.of(context).size.width * .5,
                                        MediaQuery.of(context).size.height *
                                            .05,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AllUsersScreen()),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.add_reaction_outlined,
                                      size: 28,
                                      color: Color.fromARGB(255, 103, 141, 208),
                                    ),
                                    label: const Text(
                                      "Make Some Connections",
                                      style: TextStyle(
                                          fontSize: 16,fontWeight: FontWeight.w500, color: Color.fromARGB(255, 103, 141, 208),),
                                    ),
                                  ),
                                );
                              }
                          }
                        },
                      ))),
            ],
          ),
        ),
      ),
    );
  }

  // Show Bottom Shit for new post
  void _showPostBottomShit() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return Scaffold(
            // backgroundColor: Colors.red,
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(
                                            Icons.clear,
                                            size: 24,
                                          )),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "New Post",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Body,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      _image != null
                                          ? Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image:
                                                        NetworkImage(_image!),
                                                    fit: BoxFit.cover),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              width: 150,
                                              height: 150,
                                              child: IconButton(
                                                  onPressed: () {
                                                    _showBottomShit();
                                                  },
                                                  icon: const Icon(
                                                    Icons.post_add_outlined,
                                                    size: 50,
                                                  )),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Background),
                                              width: 150,
                                              height: 150,
                                              child: IconButton(
                                                  onPressed: () {
                                                    _showBottomShit();
                                                  },
                                                  icon: const Icon(
                                                    Icons.post_add_outlined,
                                                    size: 40,
                                                    color: Body,
                                                  )),
                                            ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextFormField(
                                                  // initialValue: "#nature",
                                                  controller:
                                                      _mentionTextController,
                                                  decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      prefixIcon: const Icon(
                                                          Icons.bolt),
                                                      hintText:
                                                          "Just Burn Out.",
                                                      labelText: "Mention")),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              TextFormField(
                                                  controller:
                                                      _locationTextController,
                                                  // initialValue: 's',
                                                  decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      prefixIcon: const Icon(Icons
                                                          .pin_drop_outlined),
                                                      hintText: "Naya Raipur",
                                                      labelText: "Location")),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        flex: 5,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Background,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                            child: Column(
                              children: [
                                // input Form
                                TextFormField(
                                    controller: _titleTextController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        prefixIcon: const Icon(Icons.label),
                                        hintText: "Just Burn Out.",
                                        labelText: "Title")),
                                const SizedBox(
                                  height: 20,
                                ),

                                ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        shape: const StadiumBorder(),
                                        backgroundColor: Colors.white,
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width *
                                                .9,
                                            MediaQuery.of(context).size.height *
                                                .06)),
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus;
                                      setState(() {
                                        _loading = true;
                                      });

                                      await APIs.uploadPostPicture(
                                              APIs.selfInfo,
                                              _mentionTextController.text,
                                              _titleTextController.text,
                                              _locationTextController.text,
                                              File(_image!))
                                          .then((value) {
                                        setState(() {
                                          _loading = false;
                                        });
                                        Navigator.pop(context);
                                      });
                                    },
                                    icon: _loading
                                        ? const Icon(
                                            Icons.circle_outlined,
                                            size: 28,
                                            color: PrimaryBlue,
                                          )
                                        : const Icon(
                                            Icons.post_add_outlined,
                                            size: 28,
                                            color: Colors.black,
                                          ),
                                    label: _loading
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : const Text(
                                            "Post",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          )),
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  // Show Bottom Shit for uploding pic .
  void _showBottomShit() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 30, bottom: 60),
            children: [
              const Text(
                "Pick Profile Pictures ",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);

                        if (image != null) {
                          debugPrint("Image Path : ${image.path}");
                          //update image
                          setState(() {
                            _image = image.path;
                          });
                          // APIs.uploadStatusPicture(File(_image!));
                          //for hide bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.white,
                          fixedSize: const Size(80, 80)),
                      child: Image.asset('assets/images/picture.png')),
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);

                        if (image != null) {
                          debugPrint("Image Path : ${image.path}");
                          //update image
                          setState(() {
                            _image = image.path;
                          });
                          // APIs.uploadStatusPicture(File(_image!));
                          //for hide bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.white,
                          fixedSize: const Size(80, 80)),
                      child: Image.asset('assets/images/camera.png')),
                ],
              )
            ],
          );
        });
  }
}
