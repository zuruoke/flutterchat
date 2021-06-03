import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterchat/state/auth_state.dart';
import 'package:flutterchat/utils/enums.dart';
import 'package:flutterchat/views/homepage.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _focusPassword = FocusNode();
  bool emailValidated = false;
  bool passwordValidated = false;

  @override
  void initState() { 
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
    
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _focusPassword.dispose();
    super.dispose();
  }

  void showSnackbar(String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void doNothingAction(){
    print('');
  }

  checkOnChangedEmail(String _value){
    if (_value.length > 8){
      setState(() {
         emailValidated = true;     
    });
    }
    else if (_value.length < 8){
      setState(() {
        emailValidated = false;       
      });
    }
  }

  checkOnChangedPassword(String _value){
    if (_value.length >= 6){
      setState(() {
         passwordValidated = true;     
    });
    }
    else if (_value.length < 6){
      setState(() {
        passwordValidated  = false;       
      });
    }
  }

  _submitLogin() async {
    AuthState state = Provider.of<AuthState>(context, listen: false);
    await state.signInWithEmailAndPassword(context, emailController.text.trim(), passwordController.text);
    if (state.authStatus == AuthStatus.Logged_In){
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    }
    else{ 
      showSnackbar(state.errorMessage!);
    }
    state.errorMessage = null;
  }


  _appBar(){
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: 
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
          child: Text("Sign Up", style: TextStyle(color: Colors.brown, fontSize: 18),),
          onPressed: (){},
          ),
        )
      ],
    );
  }

  _entryField(TextEditingController textEditingcontroller, String text, bool isPassword, bool isEmail){
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
        onChanged: (_value){
          isEmail ? checkOnChangedEmail(_value) : checkOnChangedPassword(_value);
        },
        focusNode: isPassword ? _focusPassword : null,
        onSubmitted: (_) {
          isEmail ? FocusScope.of(context).requestFocus(_focusPassword) : doNothingAction();
        },
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

  _forgotPassword(){
    return Align(
      child: TextButton(
        child: Text("Forgot your password?", style: TextStyle(color: Colors.brown, fontSize: 18),),
      onPressed: (){},
          ),
        ); 
  }
  

  _loginButton(){
    Size mq = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left: 0.05 * mq.width, right: 0.05 * mq.width,),
      child: Container(
        height: 50,
      width: 0.9 * mq.width,
       child: TextButton(
         onPressed: _submitLogin,
         style: TextButton.styleFrom(
           backgroundColor: emailValidated & passwordValidated ? Colors.brown : Colors.brown[300],
           shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),),
         ),
         child: Text("Log In", style: TextStyle(color: Colors.white, fontSize: 19),)
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
      child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 0.08 * mq.width,
            right: 0.08 * mq.width,
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _entryField(emailController, 'Email', false, true),
            SizedBox(height: 25,),
            _entryField(passwordController, 'Password', true, false),
            SizedBox(height: 60,),
            _forgotPassword(),
            SizedBox(height: 40,),
            _loginButton()

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
                child: Text('Log In', 
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