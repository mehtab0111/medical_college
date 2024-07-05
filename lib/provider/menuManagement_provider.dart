import 'dart:convert';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/model/menuManagement_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MenuManagementProvider with ChangeNotifier {

  List<MenuManagement> menuManagementList = [];

  Future<void> fetchData() async {
    String url = APIData.getMenuManagement;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader);
    if(response.statusCode == 200){
      final jsonData = jsonDecode(response.body);
      // print(jsonData);
      menuManagementList = (jsonData['data'] as List)
          .map((itemJson) => MenuManagement.fromJson(itemJson))
          .toList();
      notifyListeners();
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load branch data');
    }
  }
}