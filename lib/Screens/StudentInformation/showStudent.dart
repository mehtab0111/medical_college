import 'dart:async';
import 'dart:convert';
import 'package:medical_college/Components/DialougBox/deletePopUp.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Screens/StudentInformation/editStudent.dart';
import 'package:medical_college/Screens/emptyScreen.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowStudent extends StatefulWidget {
  const ShowStudent({super.key});

  @override
  State<ShowStudent> createState() => _ShowStudentState();
}

class _ShowStudentState extends State<ShowStudent> {

  final StreamController _streamController = StreamController();
  TextEditingController search = TextEditingController();
  bool searchEnable = false;

  @override
  void initState() {
    super.initState();
    getStudents();
  }

  List _filteredItem = [];
  Future<String> getStudents() async {
    String url = APIData.getStudents;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader);
    if(response.statusCode == 200){
      final jsonData = jsonDecode(response.body);
      print(jsonData);
      _streamController.add(jsonData['data']);
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          var data = snapshot.data;
          _filteredItem = data.where((data) =>
              data['first_name'].toString().toLowerCase().contains(search.text)).toList();
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0.0,
              title: searchEnable != true ? Text('Show Student') :
              SearchTextField(
                controller: search,
                onChanged: (value){
                  setState(() {
                    _filteredItem = data.where((data) =>
                        data['first_name'].toString().toLowerCase().contains(search.text)).toList();
                  });
                },
              ),
              actions: [
                IconButton(
                  onPressed: (){
                    setState(() {
                      searchEnable = !searchEnable;
                      search.clear();
                    });
                  },
                  icon: Icon(!searchEnable ? Icons.search : Icons.close),
                ),
              ],
            ),
            body: _filteredItem.isNotEmpty ? ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              physics: BouncingScrollPhysics(),
              itemCount: _filteredItem.length,
              itemBuilder: (context, index){
                String middleName = _filteredItem[index]['middle_name'] != null ?
                '${_filteredItem[index]['middle_name']} ' : '';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: roundedContainerDesign(context).copyWith(
                      boxShadow: boxShadowDesign(),
                    ),
                    child: Column(
                      children: [
                        kRowText('ID: ', '${_filteredItem[index]['id']}'),
                        kRowText('Student Name: ', '${_filteredItem[index]['first_name']} $middleName${_filteredItem[index]['last_name']}'),
                        kRowText('Gender: ', _filteredItem[index]['gender'] == 'male' ? 'Male' : 'Female'),
                        kRowText('Date of Birth: ', _filteredItem[index]['dob']),
                        kRowText('Blood Group: ', _filteredItem[index]['blood_group'] ?? ''),
                        kRowText('Type: ', _filteredItem[index]['user_type'].toString()),
                        kRowText('Email: ', _filteredItem[index]['email']),
                        Row(
                          children: [
                            MaterialButton(
                              color: kRedColor,
                              textColor: kWhiteColor,
                              shape: materialButtonDesign(),
                              child: Text(_filteredItem[index]['status'] == 1 ? 'Disable' : 'Enable'),
                              onPressed: (){
                                changeStudentStatus(studentID: _filteredItem[index]['id'].toString());
                              },
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => EditStudent()));
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: (){
                                deletePopUp(context, onClickYes: (){
                                  deleteStudent(context, studentID: _filteredItem[index]['id'].toString());
                                });
                              },
                              icon: Icon(Icons.delete_forever_outlined,
                                color: kRedColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ) : EmptyScreen(message: 'No Student Found'),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Show Student'),
          ),
          body: LoadingIcon(),
        );
      }
    );
  }

  Future<String> changeStudentStatus({required String studentID}) async {
    String url = APIData.changeStudentStatus;
    var response = await http.get(Uri.parse('$url/$studentID'), headers: APIData.kHeader);
    if(response.statusCode == 200){
      toastMessage(message: 'Student Status Updated');
      getStudents();
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  Future<String> deleteStudent(context, {required String studentID}) async {
    String url = APIData.deleteMember;
    var response = await http.get(Uri.parse('$url/$studentID'), headers: APIData.kHeader);
    if(response.statusCode == 200){
      toastMessage(message: 'Student Deleted');
      Navigator.pop(context);
      getStudents();
    } else {
      print(response.statusCode);
      Navigator.pop(context);
    }
    return 'Success';
  }
}
