import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:formularios/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:formularios/provider/providers.dart';
import 'package:formularios/services/products_service.dart';
import 'package:formularios/styles/input_decoration.dart';
import 'package:formularios/widgets/widgets.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productServices = Provider.of<ProductsService>(context);
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productServices.selectedProduct),
      child: ProductScreen(productServices: productServices),
    );
  }
}

class ProductScreen extends StatelessWidget {
  const ProductScreen({
    Key? key,
    required this.productServices,
  }) : super(key: key);

  final ProductsService productServices;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        //backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(url: productServices.selectedProduct.picture),
                _ButtonBar(),
                Positioned(
                    top: 15,
                    right: 30,
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        final picker = new ImagePicker();
                        final XFile? image =
                            //await picker.pickImage(source: ImageSource.camera);
                            await picker.pickImage(source: ImageSource.gallery);

                        if (image == null) {
                          print('No se selecciono la foto');
                          return;
                        }
                        productServices.updateSelectedProductImage(image.path);
                        //print('La imagen es ${image.path}');
                      },
                    )),
                Positioned(
                    top: 15,
                    left: 15,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back_ios_new_outlined,
                          size: 30, color: Colors.white),
                    ))
              ],
            ),
            _ProductForm(),
          ],
        ),
      ),
    );
  }
}

class _ButtonBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(45), topLeft: Radius.circular(45)),
          //bottomLeft: Radius.circular(45),
          //bottomRight: Radius.circular(45)),
          color: Color.fromRGBO(0, 172, 180, 0.3),
        ),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
  }) : super(key: key);

  get formKey => null;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;
    final productServices = Provider.of<ProductsService>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          decoration: decorationForm(),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.black),
                  initialValue: product.name,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Control PGEA...', labelText: 'Nombre:'),
                  onChanged: (value) => product.name = value,
                  validator: (value) {
                    if (value == null || value.length < 1)
                      return 'El nombre del producto es necesario';
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.black),
                  //Expresión regular para números, con dos decimales.
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  initialValue: product.price.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: '\$150', labelText: 'Precio:'),
                  onChanged: (value) {
                    double.tryParse(value) == null
                        ? product.price = 0
                        : product.price = double.tryParse(value);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: product.description,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Descripción del producto...',
                      labelText: 'Descripción:'),
                  onChanged: (value) => product.description = value,
                  validator: (value) {
                    if (value == null || value.length < 1)
                      return 'La descripción es necesaria';
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                SwitchListTile(
                    activeColor: Colors.cyan,
                    title: Text(
                      'Disponible',
                      style: TextStyle(color: Colors.black54),
                    ),
                    value: product.available,
                    onChanged: productForm.updateAvailablility),
                SizedBox(
                  height: 10,
                ),
                SaveButton(
                    productForm: productForm,
                    productServices: productServices,
                    product: product),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration decorationForm() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: Offset(0, 5),
              blurRadius: 5)
        ]);
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({
    Key? key,
    required this.productForm,
    required this.productServices,
    required this.product,
  }) : super(key: key);

  final ProductFormProvider productForm;
  final ProductsService productServices;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        splashColor: Color.fromRGBO(0, 93, 124, 1),
        disabledColor: Colors.grey.shade500,
        color: Color.fromRGBO(0, 172, 180, 1),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
            child: productServices.isSaving
                ? CircularProgressIndicator(
                    color: Color.fromRGBO(0, 172, 180, 1),
                  )
                : Text(
                    'Guardar',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
        onPressed: productServices.isSaving
            ? null
            : () async {
                if (productForm.isValidForm()) return;
                final String? imagenUrl = await productServices.uploadImage();
                //print(imagenUrl);
                if (imagenUrl != null) productForm.product.picture = imagenUrl;
                await productServices.saveOrCreateProduct(product);
                Navigator.pop(context);
              });
  }
}
