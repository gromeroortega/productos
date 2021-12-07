import 'dart:ui';

import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Productos'),
        ),
        body: Center(
          child: CircularProgressIndicator(
            //backgroundColor: Colors.grey,
            strokeWidth: 7,
            valueColor:
                AlwaysStoppedAnimation<Color>(Color.fromRGBO(0, 172, 180, 1)),
          ),
        ));
  }
}
