// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types

import 'dart:io';

import 'package:bataao/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/apis.dart';
import '../../models/chat_user.dart';
import '../../models/status_model.dart';
import '../all_users_screen/all_users_screen.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key, required this.user});

  final ChatUser user;

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  // Form Key

  final _formKey = GlobalKey<FormState>();
  // for handeling title text..
  final _textController = TextEditingController();

  // for stogring all messages ..
  List<ChatUser> _list = [];

  List<Status> _sList = [];

  // for all connections
  List<String> _connList = [];

  // For status user index..
  var _userIndex;

  // loading
  bool _loading = false;

  // bool _statusViewState = false;

  String? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 10,
                  child: _userIndex != null
                      ? StreamBuilder(
                          stream: APIs.getAllUserStatus(_list[_userIndex]),
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

                                _sList = data
                                        ?.map((e) => Status.fromJson(e.data()))
                                        .toList() ??
                                    [];

                                if (_sList.isNotEmpty) {
                                  return ListView.builder(
                                      itemCount: _sList.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return _statusView(
                                            status: _sList[index]);
                                      });
                                } else {
                                  return Container(
                                    decoration: const BoxDecoration(
                                        // color: kLightSecondaryColor,
                                        color: primaryColor,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            topLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20))),
                                    child: Column(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: const BoxDecoration(
                                                    color: primaryColor),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20),
                                                        child: Text(
                                                          "Mood",
                                                          style: TextStyle(
                                                              fontSize: 22,
                                                              color:
                                                                  PrimaryBlue),
                                                        )),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10),
                                                        child: IconButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            icon: const Icon(
                                                              Icons.clear,
                                                              size: 26,
                                                            ))),
                                                  ],
                                                ))),
                                        Expanded(
                                          flex: 12,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20),
                                                        bottomLeft:
                                                            Radius.circular(20),
                                                        bottomRight:
                                                            Radius.circular(
                                                                20)),
                                                gradient: BG_Gradient),
                                            child: Center(
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 30,
                                                              vertical: 8),
                                                      child: Text(
                                                        "Opps ! Their has no mood ",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                            }
                          },
                        )
                      : Container(
                          decoration: const BoxDecoration(
                              // color: kLightSecondaryColor,
                              color: primaryColor,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: const BoxDecoration(
                                          color: primaryColor),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Text(
                                                "mood",
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    color: Body,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon:
                                                      const Icon(Icons.clear))),
                                        ],
                                      ))),
                              Expanded(
                                  flex: 12,
                                  child: Container(
                                    decoration:  BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black26
                                      ),
                                        gradient: BG_Gradient,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20))),
                                    child: Center(
                                        child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                                shape: const StadiumBorder(),
                                                backgroundColor: Colors.white,
                                                minimumSize: Size(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        .5,
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        .06)),
                                            onPressed: () {
                                              _showStatusBottomShit();
                                            },
                                            icon: const Icon(
                                              Icons.bolt_outlined,
                                              size: 28,
                                              color: Colors.black,
                                            ),
                                            label: const Text(
                                              "tell your mood",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ))),
                                  )),
                            ],
                          ),
                        )),
              Expanded(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(color: primaryColor,),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: StreamBuilder(
                        stream: APIs.getAllStatusUsers(),
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
                              _connList = data?.map((e) => e.id).toList() ?? [];

                              if (_connList.isNotEmpty) {
                                return StreamBuilder(
                                  stream: APIs.getSalectedUserData(_connList),
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
                                        _list = data
                                                ?.map((e) =>
                                                    ChatUser.fromJson(e.data()))
                                                .toList() ??
                                            [];

                                        if (_list.isNotEmpty) {
                                          return ListView.builder(
                                              itemCount: _list.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          if (_statusViewState ==
                                                              true) {
                                                            _userIndex = index;
                                                          } else {
                                                            _statusViewState ==
                                                                true;
                                                            _userIndex = index;
                                                          }
                                                        });
                                                      },
                                                      child: CircleAvatar(
                                                        radius: 25,
                                                        backgroundColor:
                                                            PrimaryBlue,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                _list[index]
                                                                    .images),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    )
                                                  ],
                                                );
                                              });
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
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AllUsersScreen()));
                                    },
                                    child: const Text(
                                      "no connection's",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                );
                              }
                          }
                        },
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // for upload ing status

  // Show Bottom Shit for new post
  void _showStatusBottomShit() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Form(
              key: _formKey,
              child: SafeArea(
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
                                            setState(() {
                                              _image = null;
                                            });
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(
                                            Icons.clear,
                                            size: 28,
                                          )),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "Make Some Memories",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _image != null
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: FileImage(
                                                          File(_image!)),
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                width: 150,
                                                height: 150,
                                                child: const Center(
                                                  child: Icon(
                                                      Icons.done_all_outlined),
                                                ),
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: const Color.fromARGB(
                                                        255, 231, 223, 223)),
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
                                              ),

                                        // Expanded(
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.symmetric(
                                        //         horizontal: 10),
                                        //     child: Column(
                                        //       mainAxisAlignment:
                                        //           MainAxisAlignment.spaceBetween,
                                        //       children: [
                                        //         TextFormField(
                                        //             initialValue: "#nature",
                                        //             decoration: InputDecoration(
                                        //                 border: OutlineInputBorder(
                                        //                   borderRadius:
                                        //                       BorderRadius.circular(
                                        //                           10),
                                        //                 ),
                                        //                 prefixIcon:
                                        //                     Icon(Icons.bolt),
                                        //                 hintText: "Just Burn Out.",
                                        //                 labelText: "Title")),
                                        //         SizedBox(
                                        //           height: 20,
                                        //         ),
                                        //         TextFormField(
                                        //             decoration: InputDecoration(
                                        //                 border: OutlineInputBorder(
                                        //                   borderRadius:
                                        //                       BorderRadius.circular(
                                        //                           10),
                                        //                 ),
                                        //                 prefixIcon: Icon(Icons
                                        //                     .pin_drop_outlined),
                                        //                 hintText: "Naya Raipur",
                                        //                 labelText: "Location")),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 5,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Background,
                              // gradient: gradient3,
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
                                    controller: _textController,
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
                                      // for hiding keyboard
                                      FocusScope.of(context).unfocus;
                                      setState(() {
                                        _loading = true;
                                      });
                                      // upload status data
                                      await APIs.uploadStatusPicture(
                                              widget.user,
                                              _textController.text,
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
                                          ))
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

  // Show Bottom Shit for uploding profile pic .
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
                "Pick Image",
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
                            StatusScreen(
                              user: widget.user,
                            );
                            // ignore: invalid_use_of_protected_member
                            (context as Element).reassemble();
                          });

                          //for hide bottom sheet
                          // ignore: use_build_context_synchronously
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

                          //for hide bottom sheet
                          // ignore: use_build_context_synchronously
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

class _statusView extends StatefulWidget {
  const _statusView({
    required this.status,
  });
  final Status status;

  @override
  State<_statusView> createState() => _statusViewState();
}

class _statusViewState extends State<_statusView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          // color: kLightSecondaryColor,

          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              topLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      child: Column(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(color: White),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            widget.status.title,
                            style: const TextStyle(
                                fontSize: 22, color: PrimaryBlue),
                          )),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.clear,
                                size: 26,
                              ))),
                    ],
                  ))),
          Expanded(
            flex: 12,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.status.link),
                      fit: BoxFit.cover),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: Body),
            ),
          ),
        ],
      ),
    );
  }
}
