import 'package:flutter/material.dart';
import 'package:formularios/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:formularios/services/services.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthServices>(context, listen: false);

    return Container(
      child: FutureBuilder(
        future: authService.refreshToken(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (!snapshot.hasData) return Wait();

          if (snapshot.data == '') {
            Future.microtask(() {
              //print(snapshot.data);
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => LoginScreen(),
                      transitionDuration: Duration(seconds: 0)));
            });
          } else {
            Future.microtask(() {
              //print(snapshot.data);
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => HomeScreen(),
                      transitionDuration: Duration(seconds: 0)));
            });
          }
          return Container(
            color: Colors.white,
          );
        },
      ),
    );
  }
}

class Wait extends StatelessWidget {
  const Wait({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(0, 172, 180, 1),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 400,
              ),
              CircularProgressIndicator(
                backgroundColor: Colors.grey.shade400,
                color: Colors.white,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Un momento por favor... Oficina de Bart Storson',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
