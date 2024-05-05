
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class snackbar_todo{
  static void showScussefully(BuildContext context,String message){
    final snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  static void showFailed(BuildContext context,String message){
    final snackbar = SnackBar(content: Text(message,style: TextStyle(color: Colors.white),),backgroundColor: Colors.redAccent,);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}