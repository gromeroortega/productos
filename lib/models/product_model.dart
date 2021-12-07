import 'dart:convert';

class Product {
  Product(
      {
      //this.idProduct,
      required this.active,
      required this.description,
      required this.name,
      required this.picture,
      required this.price,
      required this.available,
      this.idProduct});

  bool active;
  String description;
  String name;
  String? picture;
  double? price;
  bool available;
  String? idProduct;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
      active: json["active"] == null ? false : json["active"],
      description: json["description"] == null ? '' : json["description"],
      name: json["name"] == null ? '' : json["name"],
      picture: json["picture"] == null ? '' : json["picture"],
      price: json["price"] == null ? 0 : json["price"].toDouble(),
      available: json["available"] == null ? false : json["available"],
      idProduct: json['idProduct']);

  Map<String, dynamic> toMap() => {
        "active": active,
        "description": description,
        "name": name,
        "picture": picture,
        "price": price,
        "available": available,
        "idProduct": idProduct
      };

  Product copy() => Product(
      active: this.active,
      description: this.description,
      name: this.name,
      picture: this.picture,
      price: this.price,
      available: this.available,
      idProduct: this.idProduct);
}
