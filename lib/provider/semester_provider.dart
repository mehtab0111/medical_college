import 'dart:convert';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/model/semester_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SemesterProvider extends ChangeNotifier{

  List<Semester> semesterList = [];

  Future<void> fetchData() async {
    String url = APIData.getSemester;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader);
    if(response.statusCode == 200){
      final jsonData = jsonDecode(response.body);
      // print(jsonData);
      semesterList = (jsonData['data'] as List)
          .map((itemJson) => Semester.fromJson(itemJson))
          .toList();
      notifyListeners();
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load branch data');
    }
  }
}