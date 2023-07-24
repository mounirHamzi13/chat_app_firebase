import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_application_1/widgets/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final docs = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final userId = docs[index]['userId'] as String;
            return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .get(),
              builder: (context, userSnapshot) {
                print(userSnapshot);
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (userSnapshot.hasError) {
                  return Text('Error fetching user');
                }
                final username =
                    userSnapshot.data?.data()?['username'] as String? ??
                        'Unknown User';
                final userImage =
                    userSnapshot.data!.data()!['imageUrl'] as String;
                // final userImage = userSnapshot.data!['imageUrl'] as String;
                return MessageBubble(
                  docs[index]['text'],
                  docs[index]['userId'] ==
                      FirebaseAuth.instance.currentUser!.uid,
                  docs[index]['userId'],
                  username,
                  userImage,
                  key: ValueKey(docs[index].id),
                );
              },
            );
          },
        );
      },
    );
  }
}
