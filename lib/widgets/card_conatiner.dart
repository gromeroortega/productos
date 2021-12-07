import 'package:flutter/material.dart';

class CardConatainer extends StatelessWidget {
  final Widget child;
  const CardConatainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Color.fromRGBO(255, 255, 255, 0.9),
        // boxShadow: [
        //   BoxShadow(color: Colors.cyan, blurRadius: 0, offset: Offset(0, 0))
        // ],
      ),
      child: this.child,
    );
  }
}
