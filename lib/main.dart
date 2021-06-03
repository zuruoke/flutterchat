import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterchat/state/app_state.dart';
import 'package:flutterchat/state/auth_state.dart';
import 'package:flutterchat/views/auth_screens/landing_pade.dart';
import 'package:flutterchat/views/homepage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(FlutterChat());
}

class FlutterChat extends StatefulWidget {

  _FlutterChatState createState() => _FlutterChatState();
}

class _FlutterChatState extends State<FlutterChat> {
  String? uid;

  @override
  void initState() {
    getUserCachedId(); 
    super.initState();
    
  }

  getUserCachedId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      uid =  _prefs.getString('userId');      
    });
  }

  @override
  Widget build (BuildContext context){
    return MultiProvider(
    providers: [
      ChangeNotifierProvider<AppState>(create: (_) => AppState()),
      ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
    ],

    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      //darkTheme: ThemeData.dark(),
      home: uid != null ? HomePage(uid: uid!) : LandingPage(),
    ),
    );
  }
}


