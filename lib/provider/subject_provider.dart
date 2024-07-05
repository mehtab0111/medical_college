import 'dart:convert';
import 'package:medical_college/Services/apiData.dart';
import 'package:http/http.dart' as http;
import 'package:medical_college/model/subject_model.dart';
import 'package:flutter/material.dart';

class SubjectProvider with ChangeNotifier{

  List<Subject> subjectList = [];

  Future<void> fetchData() async {
    String url = APIData.getSubject;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader);
    if(response.statusCode == 200){
      final jsonData = jsonDecode(response.body);
      // print(jsonData);
      subjectList = (jsonData['data'] as List)
          .map((itemJson) => Subject.fromJson(itemJson))
          .toList();
      notifyListeners();
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load branch data');
    }
  }
}