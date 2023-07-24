import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String userId;
  final String userName;
  final String userImage;
  final Key key;

  MessageBubble(
      this.message, this.isMe, this.userId, this.userName, this.userImage,
      {required this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: isMe? TextDirection.rtl : TextDirection.ltr,
      mainAxisAlignment:
              MainAxisAlignment.start ,
      children: [
        CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(userImage) ,
            ),
        Container(
          constraints: BoxConstraints(minWidth: 200, maxWidth: 300),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  userName,
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              // },
              // ),
              Text(
                message,
                maxLines: 100,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  color: isMe
                      ? Colors.black
                      : Theme.of(context).textTheme.headline6!.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
