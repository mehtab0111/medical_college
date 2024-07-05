import 'dart:async';
import 'dart:convert';
import 'package:medical_college/Components/DialougBox/deletePopUp.dart';
import 'package:medical_college/Components/util.dart';
import 'package:http/http.dart' as http;
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/localDatabase.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({super.key});

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {

  final StreamController _streamController = StreamController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController subjectName = TextEditingController();
  TextEditingController subjectCode = TextEditingController();

  String subjectID = '';
  bool updateData = false;

  @override
  void initState() {
    super.initState();
    getSubject();
  }

  void getSubject() async {
    String url = APIData.getSubject;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader,);
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      _streamController.add(jsonData['data']);
    } else {
      print(response.statusCode);
    }
  }

  void saveSubject() async {
    String url = APIData.saveSubject;
    var response = await http.post(Uri.parse(url), headers: APIData.kHeader,
      body: jsonEncode({
        "name" : subjectName.text,
        "subject_code" : subjectCode.text,
      }),
    );
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      subjectName.clear();
      subjectCode.clear();
      toastMessage(message: 'Subject Added');
      getSubject();
    } else {
      print(response.statusCode);
    }
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
        title: Text('Subject'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                decoration: roundedContainerDesign(context),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text('Add Subject', style: kBoldStyle()),
                      ),
                      KTextField(title: 'Subject Name', controller: subjectName,),
                      KTextField(title: 'Subject Code', controller: subjectCode,),
                      SizedBox(height: 5.0),
                      Center(
                        child: updateData != true ? KButton(
                          title: 'Save',
                          onClick: (){
                            if(_formKey.currentState!.validate()){
                              saveSubject();
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
                                    updateSubject();
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
                                      subjectName.text = '';
                                      subjectCode.text = '';
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: containerDesign(context),
              child: Column(
                children: [
                  Text('Subject List'.toUpperCase(), style: kHeaderStyle()),
                  // KTextField(title: 'Search'),
                  StreamBuilder(
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        var data = snapshot.data;
                        return data.isNotEmpty ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          itemCount: data.length,
                          itemBuilder: (context, index){
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Container(
                                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                                decoration: roundedContainerDesign(context).copyWith(
                                  boxShadow: boxShadowDesign(),
                                ),
                                child: Column(
                                  children: [
                                    kRowText('Subject: ', '${data[index]['name']}'),
                                    kRowText('Subject Code: ', '${data[index]['subject_code']}'),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          onPressed: (){
                                            setState(() {
                                              subjectID = '${data[index]['id']}';
                                              subjectName.text = '${data[index]['name']}';
                                              subjectCode.text = '${data[index]['subject_code']}';
                                              updateData = true;
                                            });
                                          },
                                          child: Text('Edit'),
                                        ),
                                        TextButton(
                                          onPressed: (){
                                            deletePopUp(context, onClickYes: (){
                                              deleteSubject(id: data[index]['id'].toString());
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ) : Text('No Subject Found');
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

  Future<String> updateSubject() async {
    String url = APIData.updateSubject;
    var response = await http.post(Uri.parse(url), headers: APIData.kHeader,
      body: jsonEncode({
        "id": subjectID,
        "name" : subjectName.text,
        "subject_code" : subjectCode.text,
      }),
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Subject Updated');
      setState(() {
        subjectName.text = '';
        subjectCode.text = '';
        updateData = false;
      });
      getSubject();
    } else {
      print(response.statusCode);
      print(response.body);
    }
    return 'Success';
  }

  Future<String> deleteSubject({required String id}) async {
    String url = APIData.deleteSubject;
    var response = await http.get(Uri.parse('$url/$id'), headers: APIData.kHeader);
    if(response.statusCode == 200){
      toastMessage(message: 'Subject Deleted');
      getSubject();
    } else {
      print(response.statusCode);
      print(response.body);
    }
    return 'Success';
  }
}
