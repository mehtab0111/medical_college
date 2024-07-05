import 'dart:async';
import 'dart:convert';
import 'package:medical_college/Components/DialougBox/deletePopUp.dart';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Department extends StatefulWidget {
  const Department({super.key});

  @override
  State<Department> createState() => _DepartmentState();
}

class _DepartmentState extends State<Department> {

  final StreamController _streamController = StreamController();
  TextEditingController department = TextEditingController();
  TextEditingController updateDepart = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getDepartment();
  }

  Future<String> getDepartment() async {
    String url = APIData.getDepartment;
    var response = await http.get(Uri.parse(url),
      headers: APIData.kHeader,
    );
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      _streamController.add(jsonData['data']);
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  Future<String> saveDepartment() async {
    String url = APIData.saveDepartment;
    var response = await http.post(Uri.parse(url),
      headers: APIData.kHeader, body: jsonEncode({
        'name': department.text
      }),
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Department Saved');
      department.clear();
      getDepartment();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Department'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: containerDesign(context),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text('Add Department', style: kHeaderStyle()),
                    SizedBox(height: 5.0),
                    KTextField(title: 'Enter Department Name', controller: department,),
                    SizedBox(height: 5.0),
                    KButton(
                      title: 'Save',
                      onClick: (){
                        if(_formKey.currentState!.validate()){
                          saveDepartment();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: containerDesign(context),
              child: Column(
                children: [
                  Text('Department List', style: kHeaderStyle()),
                  StreamBuilder(
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        var data = snapshot.data;
                        return ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index){
                            return Container(
                              padding: EdgeInsets.only(left: 10.0),
                              decoration: roundedShadedDesign(context),
                              child: Row(
                                children: [
                                  Expanded(child: Text(data[index]['name'])),
                                  IconButton(
                                    onPressed: (){
                                      setState(() {
                                        updateDepart.text = '${data[index]['name']}';
                                      });
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context){
                                          return Container(
                                            padding: EdgeInsets.all(20),
                                            child: Column(
                                              children: [
                                                KTextField(title: 'Department Name', controller: updateDepart,),
                                                KButton(
                                                  title: 'Update',
                                                  onClick: (){
                                                    Navigator.pop(context);
                                                    updateDepartment('${data[index]['id']}');
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.edit_outlined),
                                  ),
                                  IconButton(
                                    onPressed: (){
                                      deletePopUp(
                                        context,
                                        onClickYes: (){
                                          Navigator.pop(context);
                                          deleteDepartment('${data[index]['id']}');
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return kSpace();
                          },
                        );
                      }
                      return LoadingIcon();
                    }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> updateDepartment(String departmentID) async {
    String url = APIData.updateDepartment;
    var response = await http.post(Uri.parse(url),
      headers: APIData.kHeader, body: jsonEncode({
        'id': departmentID,
        'name': updateDepart.text
      }),
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Department Updated');
      updateDepart.clear();
      getDepartment();
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  Future<String> deleteDepartment(String departmentID) async {
    String url = APIData.deleteDepartment;
    var response = await http.get(Uri.parse('$url/$departmentID'),
      headers: APIData.kHeader,
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Item deleted');
      getDepartment();
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }
}
