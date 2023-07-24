import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var enteredMessage = '';
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose(); // Call the dispose method of the controller
    super.dispose();
  }

  void sendMessage() async {
    print('heyyyyyy');
    final user = await FirebaseAuth.instance.currentUser;
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user!.uid,
    });
    setState(() {
      controller.text = '';
      controller.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Send Message...',
            ),
            onChanged: (value) {
              setState(() {
                enteredMessage = value;
              });
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: enteredMessage.trim().isEmpty ? null : sendMessage,
        )
      ],
    );
  }
}
