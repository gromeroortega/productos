import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthServices extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _fireBaseToken = 'firebaseToken';

  final storage = FlutterSecureStorage();

  //---------------------------CREAR USUARIO------------------------------------

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _fireBaseToken});
    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    if (decodeResp.containsKey('idToken')) {
      await storage.write(
          key: 'refreshToken', value: decodeResp['refreshToken']);
      await storage.write(key: 'idToken', value: decodeResp['idToken']);
      return null;
    } else {
      return 'El email ya existe';
    }
  }

//-------------------------OBTENER TOKEN----------------------------------------
  Future<String?> signIn(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final url = Uri.https(
        _baseUrl, '/v1/accounts:signInWithPassword', {'key': _fireBaseToken});
    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    if (decodeResp.containsKey('idToken')) {
      await storage.write(
          key: 'refreshToken', value: decodeResp['refreshToken']);
      await storage.write(key: 'idToken', value: decodeResp['idToken']);
      return null;
    } else {
      return 'El usuario o la contraseña no son correctos';
    }
  }

//---------------------------BORRAR TOKEN---------------------------------------
  Future logout() async {
    await storage.delete(key: 'refreshToken');
    await storage.delete(key: 'idToken');
  }

//---------------------------LEER TOKEN-----------------------------------------
  Future<String> readToken() async {
    final idToken = await storage.read(key: 'idToken') ?? '';

    return idToken;
  }

//-----------------------ATUALIZAR TOKEN-----------------------------------------
  Future<String?> refreshToken() async {
    final refreshToken = await storage.read(key: 'refreshToken');
    //print('Toquen en el secure store: $refreshToken');

    final Map<String, dynamic> refresh = {
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken
    };

    final url = Uri.https(_baseUrl, '/v1/token', {'key': _fireBaseToken});
    final resp = await http.post(url, body: json.encode(refresh));
    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    if (decodeResp.containsKey('id_token')) {
      await storage.write(
          key: 'refreshToken', value: decodeResp['refresh_token']);
      await storage.write(key: 'idToken', value: decodeResp['id_token']);
      //print('Esto es lo que manda firebase: ${decodeResp['id_token']}');
      return decodeResp['id_token'];
    } else {
      return '';
    }
  }
}
