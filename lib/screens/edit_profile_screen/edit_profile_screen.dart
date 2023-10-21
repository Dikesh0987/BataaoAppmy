// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:bataao/helper/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../api/apis.dart';
import '../../models/chat_user.dart';
import '../../theme/style.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.user});

  final ChatUser user;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Form Key

  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xffB9C1C7),

        // Main Body of this part
        body: Scaffold(
          backgroundColor: primaryColor,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Container(
                          decoration: const BoxDecoration(
                              // gradient: BG_Gradient,
                              color: primaryColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: SingleChildScrollView(
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                Stack(
                                  children: [
                                    _image != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.file(
                                              File(_image!),
                                              width: 200,
                                              height: 200,

                                              fit: BoxFit.fill,
                                              // placeholder: (context, url) => CircularProgressIndicator(),
                                            ),
                                          )
                                        : CircleAvatar(
                                            radius: 60,
                                            backgroundColor: Colors.grey,
                                            backgroundImage: NetworkImage(
                                                widget.user.images),
                                          ),
                                    Positioned(
                                      bottom: -5,
                                      right: -20,
                                      child: MaterialButton(
                                        onPressed: () {
                                          _showBottomShit();
                                        },
                                        height: 35,
                                        color: Colors.white,
                                        shape: const CircleBorder(),
                                        child: const Icon(
                                          Icons.edit,
                                          color:
                                              Color.fromARGB(255, 23, 22, 23),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  widget.user.name,
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
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 5,
                        child: Container(
                          decoration: const BoxDecoration(
                              gradient: BG_Gradient,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                            child: Column(
                              children: [
                                // input Form
                                TextFormField(
                                    initialValue: widget.user.name,
                                    onSaved: (val) =>
                                        APIs.selfInfo.name = val ?? '',
                                    validator: (val) =>
                                        val != null && val.isNotEmpty
                                            ? null
                                            : 'Requrird Field',
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        prefixIcon: const Icon(Icons.person),
                                        hintText: "eg. Dikesh Netam.",
                                        labelText: "Name")),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                    initialValue: widget.user.about,
                                    onSaved: (val) =>
                                        APIs.selfInfo.about = val ?? '',
                                    validator: (val) =>
                                        val != null && val.isNotEmpty
                                            ? null
                                            : 'Requrird Field',
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        prefixIcon:
                                            const Icon(Icons.info_outline),
                                        hintText: "eg. Dikesh Netam.",
                                        labelText: "About ")),
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
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        APIs.updateUserInfo().then((value) {
                                          DialogSnackBar.showSnackBar(
                                              context, "Updated Successfully");
                                        });
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.save,
                                      size: 28,
                                        color: Color.fromARGB(255, 103, 141, 208),
                                    ),
                                    label: const Text(
                                      "Update",
                                      style: TextStyle(
                                          fontSize: 16,  color: Color.fromARGB(255, 103, 141, 208), fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
                          APIs.uploadProfilePicture(File(_image!));
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
                          APIs.uploadProfilePicture(File(_image!));
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
