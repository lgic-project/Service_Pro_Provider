import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginLogoutProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String _token = '';
  String _role = '';

  String get role => _role;
  String get token => _token;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://20.52.185.247:8000/user/login'),
        body: jsonEncode({
          'Email': email,
          'Password': password,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['data']['token'];
        _role = data['data']['Role'];
        final role = data['data']['Role'];
        if (role == 'Provider' || role == 'admin') {
          await _storeToken(_token);
          await _storeRole(role);
          _isLoggedIn = true;
        } else {
          print('Error: Invalid role');
        }
      }
    } catch (e) {
      print('Error: $e');
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    if (_token.isNotEmpty) {
      await prefs.remove('token');
      _token = '';
      _isLoggedIn = false;
      notifyListeners();
    }
  }

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    _role = prefs.getString('role') ?? '';
    _isLoggedIn = _token.isNotEmpty;
    notifyListeners();
  }

  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> _storeRole(String role) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
  }
}
