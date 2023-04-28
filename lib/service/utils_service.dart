import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VisiableProductMoreBuy {
  String? category;
  int? buyCount;
  bool isMoreBuy=false;
  VisiableProductMoreBuy({this.buyCount, this.category, required this.isMoreBuy,});
}

class Utils {
  static Future<bool> commonDialog(context, title, content, yes, no) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return !Platform.isAndroid ?
        AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context, false);
              },
              child: Text(no, style: TextStyle(color: Colors.green, fontSize: 16),),
            ),
            TextButton(
              onPressed: (){
                Navigator.pop(context, true);
              },
              child: Text(yes, style: TextStyle(color: Colors.red, fontSize: 16),),
            )
          ],
        ) :
        CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context, false);
              },
              child: Text(no, style: TextStyle(color: Colors.green, fontSize: 16),),
            ),
            TextButton(
              onPressed: (){
                Navigator.pop(context, true);
              },
              child: Text(yes, style: TextStyle(color: Colors.red, fontSize: 16),),
            )
          ],
        );
      },
    );
  }


  static fToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey.shade400,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }
}