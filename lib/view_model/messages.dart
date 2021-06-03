import 'package:flutter/material.dart';
import 'package:flutterchat/state/auth_state.dart';
import 'package:provider/provider.dart';

class SingleMessage extends StatelessWidget {

  final String messageId;
  final String senderId;
  final String recipientId;
  final String senderUsername;
  final String recipientUsername;
  final DateTime timestamp;
  final String text;

  SingleMessage({
    required this.messageId,
    required this.senderId,
    required this.recipientId,
    required this.senderUsername,
    required this.recipientUsername,
    required this.timestamp,
    required this.text
    });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    AuthState state = Provider.of<AuthState>(context, listen: false);
    return Padding(
      padding: state.uid == senderId ? 
      EdgeInsets.only(left: 0.5 * mq.width, top: 10, bottom: 10) : 
      EdgeInsets.only(right: 0.5 * mq.width, top: 10, bottom: 10),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        width: 0.4 * mq.width,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.teal,
        ),
        child: Align(
          child: Text(text, style: TextStyle(color: Colors.white),),
        ),
      ),
      );
  }
}