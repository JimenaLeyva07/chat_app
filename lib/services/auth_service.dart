import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../global/environment.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

class AuthService with ChangeNotifier {
  UserModel user = UserModel.empty();
  bool _authenticating = false;

  bool get authenticating => _authenticating;

  String errorMessageSignUp = '';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  set authenticating(bool newValue) {
    _authenticating = newValue;
    notifyListeners();
  }

  static Future<String?> getToken() async {
    const FlutterSecureStorage tokenStorage = FlutterSecureStorage();
    final String? token = await tokenStorage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    const FlutterSecureStorage tokenStorage = FlutterSecureStorage();
    await tokenStorage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    authenticating = true;

    final Map<String, dynamic> data = <String, dynamic>{
      'email': email,
      'password': password
    };
    final http.Response response = await http.post(
      Uri.parse('${Environment.apiUrl}/login/'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    authenticating = false;
    if (response.statusCode == 200) {
      final LoginResponseModel loginResponse = LoginResponseModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      user = loginResponse.user;

      saveToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    authenticating = true;
    final Map<String, dynamic> data = <String, dynamic>{
      'name': name,
      'email': email,
      'password': password
    };

    final http.Response response = await http.post(
      Uri.parse('${Environment.apiUrl}/login/new'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    authenticating = false;
    if (response.statusCode == 200) {
      final LoginResponseModel signUpModel = LoginResponseModel.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );

      user = signUpModel.user;

      saveToken(signUpModel.token);

      return true;
    } else {
      final Map<String, dynamic> responseDecoded =
          json.decode(response.body) as Map<String, dynamic>;
      errorMessageSignUp = responseDecoded['message'].toString();

      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final String? token = await _storage.read(key: 'token');
    if (token != null) {
      final http.Response response = await http.get(
        Uri.parse('${Environment.apiUrl}/login/renew'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-token': token
        },
      );

      if (response.statusCode == 200) {
        final LoginResponseModel loginResponse = LoginResponseModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
        user = loginResponse.user;

        saveToken(loginResponse.token);

        return true;
      } else {
        logOut();
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<void> logOut() async {
    await _storage.delete(key: 'token');
  }
}

final ChangeNotifierProvider<AuthService> authNotifierProvider =
    ChangeNotifierProvider(
        (ChangeNotifierProviderRef<Object?> ref) => AuthService(),);
