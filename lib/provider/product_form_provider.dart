import 'package:flutter/material.dart';
import 'package:formularios/models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  //Saber el estado del Form
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Product product;
  ProductFormProvider(this.product);

  updateAvailablility(bool value) {
    //print(value);
    this.product.available = value;
    notifyListeners();
  }

  bool isValidForm() {
    //print(product.idProduct);
    //print(product.price);
    //print(product.available);
    return formKey.currentState?.validate() ?? false;
  }
}
