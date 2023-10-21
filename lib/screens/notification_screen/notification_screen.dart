import 'package:bataao/models/chat_user.dart';
import 'package:bataao/models/connection_model.dart';
import 'package:bataao/widgets/notification_card.dart';
import 'package:flutter/material.dart';

import '../../api/apis.dart';
import '../../theme/style.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<ChatUser> _list = [];

  List<Connection> _connList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(color: primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.clear,
                            size: 24,
                          )),
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          "notifications ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Body,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              )),
          Expanded(
              flex: 12,
              child: Container(
                  decoration: const BoxDecoration(
                      gradient: BG_Gradient,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: StreamBuilder(
                      stream: APIs.getCurrentUserAllConnections(),
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
                            _connList = data
                                    ?.map((e) => Connection.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (_connList.isNotEmpty) {
                              return ListView.builder(
                                  itemCount: _connList.length,
                                  itemBuilder: (context, index) {
                                    return StreamBuilder(
                                      stream: APIs.getConnectionsUsersData(
                                          _connList),
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          // if data has been loading
                                          case ConnectionState.waiting:
                                          case ConnectionState.none:
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );

                                          // data lodede

                                          case ConnectionState.active:
                                          case ConnectionState.done:
                                            final data = snapshot.data?.docs;
                                            _list = data
                                                    ?.map((e) =>
                                                        ChatUser.fromJson(
                                                            e.data()))
                                                    .toList() ??
                                                [];

                                            if (_list.isNotEmpty) {
                                              return CustomFollowNotifcation(
                                                user: _list[index],
                                              );
                                            } else {
                                              return const Center(
                                                child: Text(
                                                  "No Data Found",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              );
                                            }
                                        }
                                      },
                                    );
                                  });
                            } else {
                              return const Center(
                                child: Text(
                                  "Notificatios",
                                  style: TextStyle(fontSize: 20),
                                ),
                              );
                            }
                        }
                      })))
        ],
      )),
    );
  }
}
