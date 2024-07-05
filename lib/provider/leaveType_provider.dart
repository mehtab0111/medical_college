import 'dart:convert';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/model/leaveType_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LeaveTypeProvider with ChangeNotifier {

  List<LeaveType> leaveTypeList = [];

  Future<void> fetchData() async {
    String url = APIData.getLeaveType;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader);
    if(response.statusCode == 200){
      final jsonData = jsonDecode(response.body);
      // print(jsonData);
      leaveTypeList = (jsonData['data'] as List)
          .map((itemJson) => LeaveType.fromJson(itemJson))
          .toList();
      notifyListeners();
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load branch data');
    }
  }
}