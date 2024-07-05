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

class LeaveType extends StatefulWidget {
  const LeaveType({super.key});

  @override
  State<LeaveType> createState() => _LeaveTypeState();
}

class _LeaveTypeState extends State<LeaveType> {

  final StreamController _streamController = StreamController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController leaveType = TextEditingController();

  String leaveTypeID = '';
  bool updateData = false;

  @override
  void initState() {
    super.initState();
    getLeaveType();
  }

  Future<String> getLeaveType() async {
    String url = APIData.getLeaveType;
    var response = await http.get(Uri.parse(url),
      headers: APIData.kHeader,
    );
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      _streamController.add(jsonData['data']);
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  Future<String> saveLeaveType() async {
    String url = APIData.saveLeaveType;
    var response = await http.post(Uri.parse(url),
      headers: APIData.kHeader, body: jsonEncode({
         'name': leaveType.text
      }),
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Leave Type Saved');
      leaveType.clear();
      getLeaveType();
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
        title: Text('Leave Type'),
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
                    Text('Add Leave Type', style: kHeaderStyle()),
                    SizedBox(height: 5.0),
                    KTextField(title: 'Enter Leave Type Name', controller: leaveType,),
                    SizedBox(height: 5.0),
                    updateData != true ? KButton(
                      title: 'Save',
                      onClick: (){
                        if(_formKey.currentState!.validate()){
                          saveLeaveType();
                        }
                      },
                    ) : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: KButton(
                              title: 'Update',
                              onClick: (){
                                updateLeaveType();
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: KButton(
                              title: 'Cancel',
                              onClick: (){
                                setState(() {
                                  updateData = false;
                                  leaveType.clear();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
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
                  Text('Leave Type List', style: kHeaderStyle()),
                  SizedBox(height: 5.0),
                  StreamBuilder(
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        var data = snapshot.data;
                        return data.isNotEmpty ? ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index){
                            return Container(
                              padding: EdgeInsets.only(top: 5.0, left: 10.0, bottom: 5.0),
                              decoration: roundedShadedDesign(context),
                              child: Row(
                                children: [
                                  Expanded(child: Text('${data[index]['name']}')),
                                  IconButton(
                                    onPressed: (){
                                      setState(() {
                                        updateData = true;
                                        leaveTypeID = '${data[index]['id']}';
                                        leaveType.text = '${data[index]['name']}';
                                      });
                                    },
                                    icon: Icon(Icons.edit_outlined),
                                  ),
                                  IconButton(
                                    onPressed: (){
                                      deletePopUp(context, onClickYes: (){
                                        Navigator.pop(context);
                                        deleteLeaveType('${data[index]['id']}');
                                      });
                                    },
                                    icon: Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(height: 10);
                          },
                        ) : Text('No Leave Type Found');
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

  Future<String> updateLeaveType() async {
    String url = APIData.updateLeaveType;
    var response = await http.post(Uri.parse(url),
      headers: APIData.kHeader, body: jsonEncode({
        'id': leaveTypeID,
        'name': leaveType.text
      }),
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Leave Type Updated');
      setState(() {
        leaveType.clear();
        updateData = false;
      });
      getLeaveType();
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  Future<String> deleteLeaveType(String leaveType) async {
    String url = APIData.deleteLeaveType;
    var response = await http.get(Uri.parse('$url/$leaveType'),
      headers: APIData.kHeader,
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Item deleted');
      getLeaveType();
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }
}
