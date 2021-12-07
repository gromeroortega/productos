import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:formularios/models/models.dart';
import 'package:provider/provider.dart';

import 'package:formularios/services/services.dart';
import 'package:formularios/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    final product = productsService.products;
    final authService = Provider.of<AuthServices>(context, listen: false);
    if (productsService.isLoading) return LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.login_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                authService.logout();
                Navigator.pushReplacementNamed(context, 'login');
              })
        ],
      ),
      body: Products(product: product),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productsService.selectedProduct = new Product(
              active: true,
              available: true,
              description: '',
              name: '',
              picture:
                  'https://st4.depositphotos.com/14953852/24787/v/600/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg',
              price: 0);
          Navigator.pushNamed(context, 'product');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Products extends StatelessWidget {
  const Products({
    Key? key,
    required this.product,
  }) : super(key: key);

  final List<Product> product;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final productsService = Provider.of<ProductsService>(context);
        final product = productsService.products;

        return GestureDetector(
            onTap: () {
              productsService.selectedProduct = product[index].copy();
              Navigator.pushNamed(context, 'product');
            },
            child: ProductCard(product: product[index]));
      },
      itemCount: product.length,
    );
  }
}
