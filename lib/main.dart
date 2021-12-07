/*Powered by Zharka */
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:formularios/screens/screens.dart';
import 'package:formularios/services/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsService()),
        ChangeNotifierProvider(create: (_) => AuthServices())
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formularios',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      initialRoute: 'check_auth',
      routes: {
        'register': (_) => RegisterScreen(),
        'login': (_) => LoginScreen(),
        'check_auth': (_) => CheckAuthScreen(),
        'home': (_) => HomeScreen(),
        'product': (_) => ProductsScreen()
      },
      scaffoldMessengerKey: NotificationServices.messegerKey,
      theme: ThemeData.light().copyWith(
          textTheme: TextTheme(
              bodyText1: TextStyle(color: Colors.black),
              bodyText2: TextStyle(color: Colors.black87),
              headline4: TextStyle(color: Colors.grey)),
          appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: Color.fromRGBO(0, 172, 180, 1),
            //brightness: Brightness.light,
            centerTitle: true,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              elevation: 0,
              backgroundColor: Color.fromRGBO(0, 172, 180, 1),
              splashColor: Color.fromRGBO(0, 93, 124, 1))),
    );
  }
}
