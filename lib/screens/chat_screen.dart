import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_application_1/widgets/messages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../widgets/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  // void initState() {
  //   final fbm = FirebaseMessaging.instance;
  //   fbm.requestPermission();
  //   fbm.configure;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter chat'),
        actions: [
          DropdownButton(
            underline: null,
            iconEnabledColor: Colors.white,
            hint: Text(
              'Menu',
              style: TextStyle(color: Colors.white),
            ),
            items: const [
              DropdownMenuItem(
                  value: 'Logout',
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout'),
                    ],
                  ))
            ],
            onChanged: (value) {
              if (value == 'Logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween ,
        children: [Expanded(child: Messages()), NewMessage()],
      ),

      //  StreamBuilder(
      //   stream: FirebaseFirestore.instance
      //       .collection('chats/qfEzeDqttmcjHM91sgy2/messages')
      //       .snapshots(),
      //   builder: ((context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     return ListView.builder(
      //         itemCount: snapshot.data!.docs.length,
      //         itemBuilder: (context, index) => Container(
      //               padding: const EdgeInsets.all(10),
      //               child: Text(snapshot.data!.docs[index]['text']),
      //             ));
      //   }),
      // ),
    );
  }
}
