import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:formularios/provider/login_form_provider.dart';
import 'package:formularios/services/services.dart';
import 'package:formularios/styles/input_decoration.dart';
import 'package:formularios/widgets/register_background.dart';
import 'package:formularios/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: RegisterBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 220,
            ),
            CardConatainer(
                child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text('Registrate',
                    style: Theme.of(context).textTheme.headline4),
                SizedBox(
                  height: 10,
                ),
                ChangeNotifierProvider(
                  create: (_) => LoginFromProvider(),
                  child: _LoginForm(),
                )
              ],
            )),
            SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(StadiumBorder())),
              child: Text(
                '¿Ya tienes una cuenta?  Ingresar',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    )));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<LoginFromProvider>(context);
    return Container(
      //color: Colors.red,
      child: Form(
          key: formProvider.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(color: Colors.black),
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.registerInputDecoration(
                    hintText: 'john.doe@gmail.com',
                    labelText: 'Dirección de correo ',
                    prefixIcon: Icons.mail_outline),
                onChanged: (value) => formProvider.email = value,
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = new RegExp(pattern);
                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'El valor ingresado no parece un correo';
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                style: TextStyle(color: Colors.black),
                autocorrect: false,
                obscureText: true,
                //keyboardType: TextInputType.visiblePassword,
                decoration: InputDecorations.registerInputDecoration(
                    hintText: '***********',
                    labelText: 'Password',
                    prefixIcon: Icons.lock_open_outlined),
                onChanged: (value) => formProvider.password = value,
                validator: (value) {
                  if (value != null && value.length > 6) return null;
                  return 'La contraseña debe tener al menos 8 caracteres';
                },
              ),
              SizedBox(
                height: 30,
              ),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                  splashColor: Colors.deepPurpleAccent,
                  disabledColor: Colors.grey.shade500,
                  color: Color.fromRGBO(149, 121, 209, 1),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      formProvider.isLoading ? 'Espere...' : 'Registrarme',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  //Evalua si esta cargado el form
                  onPressed: formProvider.isLoading
                      ? null //Si esta cargando, inhabilita el boton
                      : () async {
                          final authService =
                              Provider.of<AuthServices>(context, listen: false);
                          //Quita el teclado
                          FocusScope.of(context).unfocus();
                          //Valida el formulario
                          if (!formProvider.isValidForm()) return;
                          //Cambiia el isLoandig a true
                          formProvider.isLoading = true;
                          final response = await authService.createUser(
                              formProvider.email, formProvider.password);
                          if (response == null) {
                            //Destruye todo el stack de las pantallas y no permite que te regreses
                            Navigator.pushReplacementNamed(context, 'home');
                          } else {
                            NotificationServices.showAlert(response);
                            formProvider.isLoading = false;
                          }
                        })
            ],
          )),
    );
  }
}
