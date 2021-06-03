import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/state/auth_state.dart';
import 'package:flutterchat/views/chat_screen.dart';
import 'package:provider/provider.dart';

class UserListItem extends StatefulWidget {

  final String uid;
  final String username;
  final String? photo;

  UserListItem({required this.uid, required this.username, this.photo});

  factory UserListItem.fromDocument(doc){
    return UserListItem(
      uid: doc.data()['id'],
      username: doc.data()['username'],
      photo: doc.data()['photo'],
    );
  }

  @override
  _UserListItemState createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {

  late final String uid;
  late final String username;
  static const String url = 'https://cdn1.iconfinder.com/data/icons/avatar-97/32/avatar-02-512.png';


  @override
  void initState() {
    AuthState state = Provider.of<AuthState>(context, listen: false);
    state.getCurrentUserValues();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    AuthState state = Provider.of<AuthState>(context, listen: false);
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey,
            backgroundImage: 
            widget.photo != null ? NetworkImage(
              widget.photo!
            ) : NetworkImage(url, scale: 0.1),
          ),
        title: Text(widget.username, style: TextStyle(fontSize: 20),),
        onTap: (){
          state.uid != widget.uid ?
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => 
            ChatScreen(
              uid: widget.uid, 
              currentUserUid: state.uid, 
              username: widget.username, 
              currentUsername: state.username
              )
            )) : print('not allowed');
        },
        ),
        SizedBox(height: 15,),
        Divider(color: Colors.black, thickness: 0.089,)
      ],
    );
  }
}
