import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:formularios/models/models.dart';

class ProductsService extends ChangeNotifier {
  final _baseURL = 'crud-flutter-store-default-rtdb.firebaseio.com';
  final storage = FlutterSecureStorage();
  final List<Product> products = [];
  bool isLoading = true;
  bool isSaving = false;
  late Product selectedProduct;
  File? fileImage;

  ProductsService() {
    this.loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    this.isLoading = true;
    notifyListeners();
    //La url se crea con la el url base + el aprtado que envia el json
    //+ el token que lee del secure storage.
    final url = Uri.https(_baseURL, 'products.json',
        {'auth': await storage.read(key: 'idToken') ?? ''});
    final resp = await http.get(url);

    //print(url);
    final Map<String, dynamic> producsMap = json.decode(resp.body);

    //Iterar para covetirlo en una lista agregandolo a la lista products
    producsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.idProduct = key;
      this.products.add(tempProduct);
    });
    this.isLoading = false;
    notifyListeners();

    return this.products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.idProduct == null) {
      //Se a crea un nuevos producto
      await this.createProduct(product);
      //print(product);
    } else {
      //Se actualiza el producto
      await this.updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String?> updateProduct(Product product) async {
    final url = Uri.https(_baseURL, 'products/${product.idProduct}.json',
        {'auth': await storage.read(key: 'idToken') ?? ''});
    await http.put(url, body: product.toJson());
    print(url);
    final index = this
        .products
        .indexWhere((element) => element.idProduct == product.idProduct);
    this.products[index] = product;
    return product.idProduct;
  }

  Future<String?> createProduct(Product product) async {
    final url = Uri.https(_baseURL, 'products.json',
        {'auth': await storage.read(key: 'idToken') ?? ''});
    final resp = await http.post(url, body: product.toJson());
    final decodeData = jsonDecode(resp.body);
    product.idProduct = decodeData['name'];
    this.products.add(product);
    print(decodeData['name']);
    return product.idProduct;
  }

  void updateSelectedProductImage(String path) {
    this.selectedProduct.picture = path;
    this.fileImage = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (this.fileImage == null) return null;

    this.isSaving = true;
    notifyListeners();
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dtgak4p66/image/upload?upload_preset=kdk4rdix');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', fileImage!.path);
    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('Algo salió muy mal, se auto destruirá en 3...2...1... Bazinga');
      //print(response.body);
      return null;
    }
    this.fileImage = null;
    final decodeData = json.decode(response.body);
    return decodeData['secure_url'];
  }
}
