import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterchat/utils/styles.dart';
import 'package:flutterchat/views/auth_screens/login_screen.dart';
import 'package:flutterchat/views/auth_screens/signup_screen.dart';

class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Size mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 0.25 * mq.height,
                decoration: canvasGradient(),
            child: Align(
              child: Text("FlutterChat", style: TextStyle(fontSize: 26, color: Colors.brown, fontWeight: FontWeight.bold),),
            ),
              ),
            SizedBox(height: 0.09 * mq.width,),
            Align(
            child: TextButton(
              child: Text("Sign Up", style: TextStyle(color: Colors.brown, fontSize: 22, fontWeight: FontWeight.bold),),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                },
          ),
            ),
            SizedBox(
              height: 0.07 * mq.height,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Have an account already?", style: TextStyle(color: Colors.black, fontSize: 20)),
                TextButton(
              child: Text("Log In", style: TextStyle(color: Colors.brown, fontSize: 20, fontWeight: FontWeight.bold),),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                },
          ),
              ],
            ),
            SizedBox(height: 0.15 * mq.height,),
            Align(
              child: Text('Copyright FlutterChat 2021', style: TextStyle(color: Colors.black, fontSize: 20) ),
            ),
            ],
          ),)
      ),
    );
  }
}