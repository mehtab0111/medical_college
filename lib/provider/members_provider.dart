import 'dart:convert';

import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/model/members_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MembersProvider with ChangeNotifier {

  List<Members> memberList = [];

  Future<void> fetchData() async {
    String url = APIData.getAllMembers;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader);
    if(response.statusCode == 200){
      final jsonData = jsonDecode(response.body);
      // print(jsonData);
      memberList = (jsonData['data'] as List)
          .map((itemJson) => Members.fromJson(itemJson))
          .toList();
      notifyListeners();
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load branch data');
    }
  }
}