// ignore_for_file: camel_case_types

import 'package:bataao/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../api/apis.dart';
import '../../models/chat_user.dart';
import '../../widgets/chat_user_card.dart';
import '../../widgets/search_user_card.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
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

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: primaryColor,
      body: _mainBody(),
    );
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

  // for searching values ..
  final List<ChatUser> _searchList = [];

  // for searching status ..
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: primaryColor,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
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
                      color: Colors.black54,
                      size: 26,
                    )),
                if (_isSearching == false)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.black54,
                          size: 26,
                        )),
                  )
              ],
              // floating: true,
              // expandedHeight: 60.0,
              // forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        body: Column(
          children: [
            Expanded(
              child: Container(
                  decoration: const BoxDecoration(
                      gradient: BG_Gradient,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: StreamBuilder(
                    stream: APIs.getAllUsers(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        // if data has been loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(
                              child: CircularProgressIndicator());

                        // data lodede

                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => ChatUser.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                itemCount: _isSearching
                                    ? _searchList.length
                                    : _list.length,
                                padding: const EdgeInsets.only(top: 5),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return _isSearching
                                      ? SearchUserCard(user: _searchList[index])
                                      : ChatUserCard(user: _list[index]);
                                });
                          } else {
                            return  Center(
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
                                      Icons.outbox_outlined,
                                      size: 28,
                                      color: Color.fromARGB(255, 103, 141, 208),
                                    ),
                                    label: const Text(
                                      "Error",
                                      style: TextStyle(
                                          fontSize: 16,fontWeight: FontWeight.w500, color: Color.fromARGB(255, 103, 141, 208),),
                                    ),
                                  ),
                                );
                          }
                      }
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
