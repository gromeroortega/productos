import 'dart:ui';

import 'package:flutter/material.dart';

class RegisterBackground extends StatelessWidget {
  final Widget child;

  const RegisterBackground({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return //
        Container(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [BackgroudRaining(), _blur(), _logo(), this.child],
            )
            //decoration: _purpleBackGround(),
            //height: size.height * 0.4,
            //child: BgPurple(),
            );
  }

  Positioned _blur() {
    return Positioned.fill(
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
          child: Container(
              //color: Colors.white.withOpacity(0.08),
              // decoration: BoxDecoration(color: Colors.transparent),
              )),
    );
  }

  SafeArea _logo() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 30),
        width: double.infinity,
        child: Icon(
          Icons.rate_review,
          color: Color.fromRGBO(149, 121, 209, 1),
          size: 100,
        ),
      ),
    );
  }
}

class BackgroudRaining extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image(
      fit: BoxFit.cover,
      image: AssetImage('assets/rainy.jpg'),
      width: double.infinity,
      height: double.infinity,
    );
  }
}

class BgPurple extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(child: Bubbles(), top: 90, right: 30),
        Positioned(child: Bubbles(), bottom: -40, left: -30),
        Positioned(child: Bubbles(), top: -27.666, right: 162.034),
        Positioned(child: Bubbles(), bottom: -50, left: 52.803),
        Positioned(child: Bubbles(), top: 180.99, right: 120.124),
        Positioned(child: Bubbles(), bottom: 25.5, left: 80.582),
        Positioned(child: Bubbles(), top: 100.691, right: 136.923),
        Positioned(child: Bubbles(), bottom: -43.864, left: 125.923),
        Positioned(child: Bubbles(), top: -6.645, right: 76.072),
        Positioned(child: Bubbles(), bottom: 199.384, left: -19.768),
      ],
    );
  }
}

class Bubbles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Color.fromRGBO(149, 121, 209, 0.6)));
  }
}

/*BoxDecoration _purpleBackGround() => BoxDecoration(
      gradient: LinearGradient(colors: [
        Color.fromRGBO(126, 184, 218, 1),
        Color.fromRGBO(146, 221, 234, 1),
        //Color.fromRGBO(255, 165, 216, 1),
        //Color.fromRGBO(190, 157, 223, 1),
        //Color.fromRGBO(149, 121, 209, 1),
      ]),
    );*/
