import 'dart:io';
import 'package:bataao/helper/my_date_util.dart';
import 'package:bataao/models/chat_user.dart';
import 'package:bataao/models/message.dart';
import 'package:bataao/screens/view_profile_screen/view_profile_screen.dart';
import 'package:bataao/widgets/message_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../api/apis.dart';
import '../../theme/style.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // for stogring all messages ..
  List<Message> _list = [];

  // for handeling text msgg
  final _textController = TextEditingController();

  // emoji bool
  bool _showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_showEmoji) {
            setState(() {
              _showEmoji = !_showEmoji;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: primaryColor,
          // App Bar
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor,
            flexibleSpace: _appBar(),
          ),

          // Chat input field
          body: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xffFFFFFF), Color(0xffD8F1FE)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter),
                      borderRadius: BorderRadius.circular(20)),
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        // if data has been loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();

                        // data lodede

                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;

                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                reverse: true,
                                itemCount: _list.length,
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessageCard(message: _list[index]);
                                });
                          } else {
                            return const Center(
                              child: Text(
                                "Say Hii ! 😊",
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),
              ),
              // circular progress  indicator ..
              if (_isUploading)
                const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                      ),
                    )),

              Container(color: White, child: _chatInput()),
              // sow emoji
              if (_showEmoji)
                SizedBox(
                  height: 300,
                  child: EmojiPicker(
                    textEditingController:
                        _textController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                    config: Config(
                      columns: 7,
                      bgColor: White,
                      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  // Custom App Bar functions ..
  Widget _appBar() {
    return SafeArea(
      child: InkWell(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => ViewProfileScreen(user: widget.user)));
          },
          child: StreamBuilder(
            stream: APIs.getUserInfo(widget.user),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                // if Data has been not loded or some error in messeing load.
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );

                // if dada has been loaded ..
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  final list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: CachedNetworkImage(
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              imageUrl: list.isNotEmpty
                                  ? list[0].images
                                  : widget.user.images,
                              // placeholder: (context, url) => CircularProgressIndicator(),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                list.isNotEmpty
                                    ? list[0].name
                                    : widget.user.name,
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                  list.isNotEmpty
                                      ? list[0].isOnline
                                          ? 'online now '
                                          : myDateUtil.getLastActiveTime(
                                              context: context,
                                              lastActive: list[0].lastActive)
                                      : myDateUtil.getLastActiveTime(
                                          context: context,
                                          lastActive: list[0].lastActive),
                                  style: list.isNotEmpty
                                      ? list[0].isOnline
                                          ? const TextStyle(
                                              fontSize: 12,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold)
                                          : const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87,
                                            )
                                      : const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ))
                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.clear,
                            size: 28,
                            color: Body,
                          ),
                        ),
                      ),
                    ],
                  );
              }
            },
          )),
    );
  }
 
  // Bottom chat input fileds ....

  Widget _chatInput() {
    return Container(
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
        child: Row(
          children: [
            Expanded(
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    // Emoji BUtton
                    IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            _showEmoji = !_showEmoji;
                          });
                        },
                        icon: const Icon(
                          Icons.emoji_emotions_outlined,
                          color: Body,
                        )),
                    // text filed for type text
                    Expanded(
                        child: TextField(
                      maxLines: null,
                      onTap: () {
                        if (_showEmoji) {
                          _showEmoji = !_showEmoji;
                        }
                      },
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                          hintText: "Just Say Hello ! ",
                          hintStyle: TextStyle(
                              color: Body, fontWeight: FontWeight.bold),
                          border: InputBorder.none),
                    )),
                    // Gallery Button
                    IconButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          // Pick multipal image
                          final List<XFile> images =
                              await picker.pickMultiImage(imageQuality: 70);
                          for (var i in images) {
                            setState(() {
                              _isUploading = !_isUploading;
                            });
                            APIs.sendChatImage(widget.user, File(i.path));
                            setState(() {
                              _isUploading = !_isUploading;
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.image,
                          color: Body,
                        )),

                    //Camera Button
                    IconButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          // Pick an image
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera, imageQuality: 70);

                          if (image != null) {
                            setState(() {
                              _isUploading = !_isUploading;
                            });
                            debugPrint("Image Path : ${image.path}");

                            APIs.sendChatImage(widget.user, File(image.path));
                            setState(() {
                              _isUploading = !_isUploading;
                            });
                            //for hide bottom sheet
                          }
                        },
                        icon: const Icon(
                          Icons.camera,
                          color: Body,
                        )),
                  ],
                ),
              ),
            ),

            // Send button
            MaterialButton(
                minWidth: 0,
                onPressed: () {
                  if (_textController.text.isNotEmpty) {
                    APIs.sendMessage(
                        widget.user, _textController.text, Type.text);
                    _textController.text = "";
                  }
                },
                color: Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.only(
                    top: 10, right: 5, left: 10, bottom: 10),
                child: const Icon(Icons.send, size: 28, color: Colors.black))
          ],
        ),
      ),
    );
  }
}
