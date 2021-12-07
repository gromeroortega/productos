import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:formularios/models/models.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      width: double.infinity,
      height: 350,
      decoration: _cardStyle(),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BackgroundImage(product: product),
          Positioned(
              top: 0,
              right: 0,
              child: ShowPrice(
                product: product,
              )),
          Positioned(top: 0, left: 0, child: _NotAviable(product: product)),
          _ProductDeatails(product: product)
        ],
      ),
    );
  }

  BoxDecoration _cardStyle() {
    return BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black12, offset: Offset(0, 7), blurRadius: 10)
        ]);
  }
}

class _NotAviable extends StatelessWidget {
  final Product product;

  const _NotAviable({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 120,
      decoration: BoxDecoration(
          color: product.available ? Colors.green[800] : Colors.red[800],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Center(
            widthFactor: 1.2,
            child: Text(
              product.available ? 'Available' : 'No Available',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
            )),
      ),
    );
  }
}

class _ProductDeatails extends StatelessWidget {
  final Product product;

  const _ProductDeatails({Key? key, required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 60),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        width: double.infinity,
        height: 78,
        decoration: _detailsBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              product.description,
              style: TextStyle(color: Colors.white, fontSize: 16),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _detailsBoxDecoration() => BoxDecoration(
      color: Color.fromRGBO(189, 106, 112, 1),
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10), topRight: Radius.circular(10)));
}

class ShowPrice extends StatelessWidget {
  final Product product;

  const ShowPrice({Key? key, required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final price = product.price.toString();
    return Container(
      height: 55,
      width: 130,
      decoration: BoxDecoration(
          color: Color.fromRGBO(0, 45, 102, 1),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), bottomLeft: Radius.circular(10))),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Center(
            widthFactor: 1.2,
            child: Text(
              '\$ $price',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900),
            )),
      ),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  final Product product;

  const BackgroundImage({Key? key, required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        height: 350,
        child: product.picture == null
            ? Image(
                image: AssetImage('assets/no-image.png'),
                fit: BoxFit.cover,
              )
            : FadeInImage(
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/jar-loading.gif'),
                image: NetworkImage(product.picture!),
              ),
      ),
    );
  }
}
