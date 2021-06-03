import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/state/auth_state.dart';
import 'package:flutterchat/utils/enums.dart';
import 'package:flutterchat/view_model/userlist_model.dart';
import 'package:flutterchat/views/auth_screens/landing_pade.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
    
  final CollectionReference userRef = FirebaseFirestore.instance.collection('users');

  final String? uid;

  HomePage({this.uid});

  getUserList (BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: userRef.get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final QuerySnapshot querySnapshot = snapshot.data!;
          List<UserListItem> userItem = [];
          userItem = querySnapshot.docs.map((
            QueryDocumentSnapshot doc) => UserListItem.fromDocument(doc)).toList();
            return SingleChildScrollView(
              child: Padding( 
                padding: EdgeInsets.only(top: 15),
                child: Column(
                children: userItem,
              ),),
            );
        }
        else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  void logout (BuildContext context) async {
    AuthState state = Provider.of<AuthState>(context, listen: false);
    await state.signOutWithEmailAndPassword();
    if (state.authStatus == AuthStatus.Not_Logged_In) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => LandingPage()));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        leading: Icon(
          Icons.checklist_rtl_sharp, size: 35, color: Colors.black,
        ),
        centerTitle: true,
        title: Text('FlutterChat', style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black
        ),),
        actions: [
          IconButton(
          padding: EdgeInsets.only(right: 10),
          onPressed: () {
            logout(context);
          },
          icon: Icon(Icons.logout, size: 25, color: Colors.black,)
          ),
        ],
      ),
      body: getUserList(context)
    );
  }
}