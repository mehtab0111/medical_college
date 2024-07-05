import 'dart:convert';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {

  List<UserModel> userList = [];

  Future<void> fetchData() async {
    String url = APIData.getAllUsers;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader);
    if(response.statusCode == 200){
      final jsonData = jsonDecode(response.body);
      // print(jsonData);
      userList = (jsonData['data'] as List)
          .map((itemJson) => UserModel.fromJson(itemJson))
          .toList();
      notifyListeners();
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load branch data');
    }
  }
}
