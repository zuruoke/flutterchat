import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterchat/state/auth_state.dart';
import 'package:flutterchat/utils/enums.dart';
import 'package:flutterchat/utils/validate_credentials.dart';
import 'package:flutterchat/views/auth_screens/add_profile_pic.dart';
import 'package:flutterchat/views/auth_screens/login_screen.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  static final bool isIOS = Platform.isIOS;

  @override
  void initState() { 
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
    
  }

  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showSnackbar(String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  submitSignUp() async {
    AuthState state = Provider.of<AuthState>(context, listen: false);
    if (usernameController.text.isEmpty){
      showSnackbar('Please Enter an unsername');
      return;
    }
    if (usernameController.text.length > 25){
      showSnackbar('username length cannot exceed 25 characters');
      return;
    }
    if (emailController.text.isEmpty) {
      showSnackbar('Please enter an Email');
      return;
    }
    var status = validateEmail(emailController.text);
    if (!status){
      showSnackbar('Enter a Valid email address');
      return;
    }
    if (passwordController.text.isEmpty) {
      showSnackbar('Please enter a password');
      return;
    }
    if (passwordController.text.length < 6){
      showSnackbar('Password must be at least 6 characters');
      return;
    }
    await state.signUpWithEmailAndPassword(
      context: context,
      email: emailController.text,
      username: usernameController.text,
      password: passwordController.text,
    );
    if (state.authStatus == AuthStatus.Logged_In) {
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddProfilePicScreen(name: usernameController.text)));
    }
    else {
      showSnackbar(state.errorMessage2!);
    }
    state.errorMessage2 = null;

  }


  _appBar(){
    return AppBar(
      backgroundColor: Colors.teal,
      elevation: 0,
      leading: IconButton(
        icon: isIOS ? Icon(Icons.arrow_back_rounded, color: Colors.black, size: 30,) :
        Icon(Icons.arrow_back_rounded, color: Colors.black, size: 30,),
        onPressed: (){
          Navigator.pop(context);
        },
        padding: EdgeInsets.only(left: 10),
      ),
      actions: [
        Padding( 
          padding: EdgeInsets.only(right: 10),
          child: TextButton(
          child: Text("Log In", style: TextStyle(color: Colors.blue, fontSize: 18),),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          },
          ),
        )
      ],
    );
  }

  _entryField(TextEditingController textEditingcontroller, String text, bool isName, bool isPassword, bool isEmail){
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
          width: 0.2,
        )
        ),
      child: TextField(
        obscureText: isPassword,
        controller: textEditingcontroller,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal
        ),
      decoration: InputDecoration(
          labelText: text,
          labelStyle: TextStyle(fontSize: 13, color: Colors.black),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
      ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    ),
      ),
    );
  }

  _signUpButton(){
    Size mq = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left: 0.05 * mq.width, right: 0.05 * mq.width,),
      child: Container(
        height: 50,
      width: 0.9 * mq.width,
       child: TextButton(
         onPressed: submitSignUp,
         style: TextButton.styleFrom(
           backgroundColor: Colors.blue,
           shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),),
         ),
         child: Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 19),)
         ),
      ),
    );
  }


  _contentScreen(){
    Size mq = MediaQuery.of(context).size;
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return Column(
      children: [
        Container(
      height: mq.height * 0.80 -
        AppBar().preferredSize.height -
        mediaQuery.padding.top,
      width: mq.width,
      child:  Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 0.08 * mq.width,
            right: 0.08 * mq.width,
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _entryField(usernameController, 'Username', true, false, false),
            SizedBox(height: 25,),
            _entryField(emailController, 'Email', false, false, true),
            SizedBox(height: 25,),
            _entryField(passwordController, 'Password', false, true, false,),
            SizedBox(height: 60,),
            _signUpButton()

          ],
        ),),
      ),
      ],);
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 0.3 * mq.width, right: 0.3 * mq.width, bottom: 20),
                child: Text('Sign Up', 
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),),
              ),
              _contentScreen(),
            ],
        ),
      ),
    ));
  }
}