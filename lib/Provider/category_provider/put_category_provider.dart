import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:service_pro_provider/Provider/login_logout_provider.dart';

class UpdateCategory with ChangeNotifier {
  Future<void> updateCategory(
      BuildContext context, String cid, String name, String image) async {
    final token =
        Provider.of<LoginLogoutProvider>(context, listen: false).token;
    try {
      print('Updating category with ID: $cid'); // Debug statement
      final response = await http.put(
        Uri.parse('http://20.52.185.247:8000/category/update/$cid'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'Name': name,
          'Image': image,
        }),
      );
      if (response.statusCode == 200) {
        print('Category updated successfully');
        print('Response: ${response.body}'); // Debug statement
        notifyListeners();
      } else {
        print(
            'Error in updating category: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error in updating category: $e');
    }
  }

  Future<String?> uploadCategoryImage(
      BuildContext context, String filePath) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://20.52.185.247:8000/upload/file'),
      );
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print('Image uploaded successfully: $responseData'); // Debug statement
        return responseData;
      } else {
        print(
            'Error uploading image: ${response.statusCode} ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Exception uploading image: $e');
      return null;
    }
  }
}
