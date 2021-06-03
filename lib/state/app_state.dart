import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier{
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set loading(bool value){
    _isLoading = true;
  notifyListeners();
  }

}


