import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:formularios/provider/login_form_provider.dart';
import 'package:formularios/services/services.dart';
import 'package:formularios/styles/input_decoration.dart';
import 'package:formularios/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: AuthBackground(
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
                Text('Login', style: Theme.of(context).textTheme.headline4),
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
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'register'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(StadiumBorder())),
              child: Text(
                '¿No tienes una cuenta? !Registrate aquí!.',
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
                decoration: InputDecorations.authInputDecoration(
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
                decoration: InputDecorations.authInputDecoration(
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
                  splashColor: Color.fromRGBO(0, 93, 124, 1),
                  disabledColor: Colors.grey.shade500,
                  color: Color.fromRGBO(0, 172, 180, 1),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      formProvider.isLoading ? 'Espere...' : 'Ingresar',
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
                          //Inicia sesión
                          final response = await authService.signIn(
                              formProvider.email, formProvider.password);
                          //Valida la respuesta del back
                          if (response == null) {
                            //Logueo Exitoso. Destruye todo el stack de las pantallas y no permite que te regreses
                            Navigator.pushReplacementNamed(context, 'home');
                          } else {
                            //Logueo no exitoso.
                            NotificationServices.showAlert(response);
                            formProvider.isLoading = false;
                          }
                        })
            ],
          )),
    );
  }
}
