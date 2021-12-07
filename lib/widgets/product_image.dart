import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? url;
  const ProductImage({Key? key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Container(
        width: double.infinity,
        //height: 400,
        decoration: _productDecoration(),
        child: Opacity(
          opacity: 0.89,
          child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(45), topLeft: Radius.circular(45)),
              child: getImage(url)),
        ),
      ),
    );
  }

  Widget getImage(String? picture) {
    if (picture == null)
      return Image(
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover,
      );
    if (picture.startsWith('http'))
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(url!),
        fit: BoxFit.cover,
      );
    return Image.file(File(picture), fit: BoxFit.cover);
  }

  BoxDecoration _productDecoration() => BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(45), topLeft: Radius.circular(45)),
          //color: Colors.black45,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05), offset: Offset(0, 5))
          ]);
}
