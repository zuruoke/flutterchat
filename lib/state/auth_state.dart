import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/state/app_state.dart';
import 'package:flutterchat/utils/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState extends AppState {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AuthStatus authStatus;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late String uid;
  late String username;
  String? errorMessage;
  String? errorMessage2;

  Future<void> signInWithEmailAndPassword(BuildContext context, String email, String password) async{
    try {
      loading = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null){
        authStatus = AuthStatus.Logged_In;
        await saveSharedPreference(uid: user.uid);   
      }
      
      } on FirebaseAuthException catch(e){
        loading = false;
        authStatus = AuthStatus.Not_Logged_In;
        if (e.code == 'user-not-found'){
        errorMessage = 'OOPS! No user found for that email.';
        }
      else if (e.code == 'wrong-password'){
        errorMessage = 'OOPS! Wrong password provided.';
        }
    } catch (error){
        errorMessage = 'Internet connection too slow';
      }
      loading = false;
    }

    
    Future<void> signUpWithEmailAndPassword({
      required BuildContext context, 
      required String email, 
      required String password, 
      required String username, 
      }) async{
    try {
      loading = true;
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null){
        authStatus = AuthStatus.Logged_In;
        saveUserInfo(uid: user.uid, email: email, username: username);
        await saveSharedPreference(uid: user.uid);
      }

    } on FirebaseAuthException catch(e){
      loading = false;
      authStatus = AuthStatus.Not_Logged_In;
      if (e.code == 'weak-password'){
        errorMessage2 = 'OOPS! The password provided is too weak.';
        }
      else if (e.code == 'email-already-in-use'){
        errorMessage2 = 'OOPS! An account already exists for this email.';
        }
    }
    loading = false;
  }

  Future<void> signOutWithEmailAndPassword() async{
    await _auth.signOut();
    authStatus = AuthStatus.Not_Logged_In;
    await removeSharedPreference();
  }

  void saveUserInfo({required String uid, required String email, required String username}){
    final userRef = _firebaseFirestore.collection('users').doc(uid);
    userRef.set({
        'id': uid,
        'email': email,
        'username': username,
        'photo': '',
    });
  }

  Future<void> saveSharedPreference({required String uid}) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', uid);
    _firebaseFirestore.collection('users').doc(uid).get()
        .then((value) {
          prefs.setString('username', value.data()!['username']);
      });
  }
  removeSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    prefs.remove('username');
  }

  getCurrentUserValues() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
      uid = _prefs.getString('userId')!;
      username = _prefs.getString('username')!;    
       
  }


}
  