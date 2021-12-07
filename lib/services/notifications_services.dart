import 'package:flutter/material.dart';

class NotificationServices {
  static GlobalKey<ScaffoldMessengerState> messegerKey =
      new GlobalKey<ScaffoldMessengerState>();

  static showAlert(String message) {
    final snackBar = SnackBar(
        duration: Duration(seconds: 4),
        dismissDirection: DismissDirection.startToEnd,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: TextStyle(
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ));

    messegerKey.currentState!.showSnackBar(snackBar);
  }
}
