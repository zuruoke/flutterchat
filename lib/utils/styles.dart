import 'package:flutter/material.dart';

BoxDecoration canvasGradient(){
  return BoxDecoration(
  borderRadius: BorderRadius.only(
    bottomLeft: Radius.circular(100.0),
    bottomRight: Radius.circular(100.0)),
  gradient: LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Colors.teal,
      Colors.greenAccent,
    ]
      ),
  );
}