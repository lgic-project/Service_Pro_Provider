import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServiceProvider with ChangeNotifier {
  List<dynamic> _service = [];

  List<dynamic> get service => _service;
  Future<void> getServices() async {
    try {
      final response =
          await http.get(Uri.parse('http://20.52.185.247:8000/service'));
      if (response.statusCode == 200) {
        _service = jsonDecode(response.body)['data'];
        notifyListeners();
      } else {
        print(
            'Error in fetching services: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error in fetching services: $e');
    }
  }
}
