import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:medical_college/Components/DialougBox/deletePopUp.dart';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';

class Designation extends StatefulWidget {
  const Designation({super.key});

  @override
  State<Designation> createState() => _DesignationState();
}

class _DesignationState extends State<Designation> {

  final StreamController _streamController = StreamController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController designation = TextEditingController();
  TextEditingController updateDesignationText = TextEditingController();
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDesignation();
  }

  Future<String> getDesignation() async {
    String url = APIData.getDesignation;
    var response = await http.get(Uri.parse(url),
      headers: APIData.kHeader,
    );
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      // print(jsonData);
      _streamController.add(jsonData['data']);
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  Future<String> saveDesignation() async {
    String url = APIData.saveDesignation;
    var response = await http.post(Uri.parse(url),
      headers: APIData.kHeader, body: jsonEncode({
        'name': designation.text
      }),
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Designation Saved');
      designation.clear();
      getDesignation();
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
        title: Text('Designation'),
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
                    Text('Add Designation', style: kHeaderStyle()),
                    SizedBox(height: 5.0),
                    KTextField(title: 'Enter Designation', controller: designation,),
                    SizedBox(height: 5.0),
                    KButton(
                      title: 'Save',
                      onClick: (){
                        if(_formKey.currentState!.validate()){
                          saveDesignation();
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
                  Text('Designation List', style: kHeaderStyle()),
                  StreamBuilder(
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        var data = snapshot.data;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index){
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Container(
                                padding: EdgeInsets.only(left: 10.0),
                                decoration: roundedShadedDesign(context),
                                child: Row(
                                  children: [
                                    Expanded(child: Text(data[index]['name'])),
                                    IconButton(
                                      onPressed: (){
                                        setState(() {
                                          updateDesignationText.text = '${data[index]['name']}';
                                        });
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context){
                                            return Container(
                                              padding: EdgeInsets.all(20),
                                              child: Column(
                                                children: [
                                                  KTextField(title: 'Department Name', controller: updateDesignationText,),
                                                  KButton(
                                                    title: 'Update',
                                                    onClick: (){
                                                      Navigator.pop(context);
                                                      updateDesignation('${data[index]['id']}');
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
                                            deleteDesignation('${data[index]['id']}');
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.delete_outline),
                                    ),
                                  ],
                                ),
                              ),
                            );
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

  Future<String> updateDesignation(String designationID) async {
    String url = APIData.updateDesignation;
    var response = await http.post(Uri.parse(url),
      headers: APIData.kHeader, body: jsonEncode({
        'id': designationID,
        'name': updateDesignationText.text
      }),
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Designation Updated');
      updateDesignationText.clear();
      getDesignation();
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  Future<String> deleteDesignation(String designationID) async {
    String url = APIData.deleteDesignation;
    var response = await http.get(Uri.parse('$url/$designationID'),
      headers: APIData.kHeader,
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Item deleted');
      getDesignation();
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }
}
