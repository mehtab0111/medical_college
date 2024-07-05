import 'dart:async';
import 'dart:convert';

import 'package:medical_college/Components/DialougBox/deletePopUp.dart';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/localDatabase.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/model/semester_model.dart';
import 'package:medical_college/provider/course_provider.dart';
import 'package:medical_college/provider/subject_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SubjectGroup extends StatefulWidget {
  const SubjectGroup({super.key});

  @override
  State<SubjectGroup> createState() => _SubjectGroupState();
}

class _SubjectGroupState extends State<SubjectGroup> {

  final StreamController _streamController = StreamController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  List<Semester> semesterList = [];
  String courseValue = '';
  String semesterValue = '';
  String oldSemesterValue = '';
  List<String> selectedSemester = [];
  List<String> selectedSubject = [];
  bool updateData = false;

  @override
  void initState() {
    super.initState();
    getSubjectGroup();
  }

  void getSubjectGroup() async {
    String url = APIData.getSubjectGroup;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader,);
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      // print(jsonData);
      _streamController.add(jsonData['data']);
    } else {
      print(response.statusCode);
    }
  }

  void saveSubjectGroup() async {
    List subjectList = [];
    for(var item in selectedSubject){
      subjectList.add({"id": item});
    }
    String url = APIData.saveSubjectGroup;
    var response = await http.post(Uri.parse(url), headers: APIData.kHeader,
      body: jsonEncode({
        "course_id": courseValue,
        "name": name.text,
        "semester_id": semesterValue,
        "subject": subjectList,
      }),
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Subject Group Added');
      setState(() {
        name.clear();
        courseValue = '';
        semesterValue = '';
        selectedSubject = [];
      });
      getSubjectGroup();
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
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    // final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final subjectProvider = Provider.of<SubjectProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Subject Group'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                decoration: roundedContainerDesign(context),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text('Add Subject Group', style: kHeaderStyle()),
                      ),
                      KTextField(title: 'Name', controller: name,),
                      Row(
                        children: [
                          SizedBox(width: 10.0),
                          Text('Course', style: kSmallText()),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                        child: Container(
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          decoration: dropTextFieldDesign(),
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton(
                                isExpanded: true,
                                borderRadius: BorderRadius.circular(10.0),
                                value: courseValue != '' ? courseValue : null,
                                hint: Text('Course'),
                                items: courseProvider.courseList
                                    .map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value.id.toString(),
                                    child: Text(value.courseName),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  print(newValue);
                                  setState(() {
                                    courseValue = newValue!;
                                    semesterList = courseProvider.courseList
                                        .firstWhere((course) => course.id.toString() == courseValue)
                                        .semester;
                                    semesterValue = '';
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10.0),
                          Text('Semester', style: kSmallText()),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                        child: Container(
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          decoration: dropTextFieldDesign(),
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton(
                                isExpanded: true,
                                borderRadius: BorderRadius.circular(10.0),
                                value: semesterValue != '' ? semesterValue : null,
                                hint: Text('Semester'),
                                items: semesterList
                                    .map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value.id.toString(),
                                    child: Text(value.name),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    semesterValue = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text('Subject', style: kBoldStyle()),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: subjectProvider.subjectList.length,
                        itemBuilder: (context, index){
                          return InkWell(
                            onTap: (){
                              if(selectedSubject.contains(subjectProvider.subjectList[index].id.toString())){
                                setState(() {
                                  selectedSubject.remove(subjectProvider.subjectList[index].id.toString());
                                });
                              } else {
                                setState(() {
                                  selectedSubject.add(subjectProvider.subjectList[index].id.toString());
                                });
                              }
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(selectedSubject.contains(subjectProvider.subjectList[index].id.toString()) ?
                                Icons.check_box :Icons.check_box_outline_blank_outlined),
                                SizedBox(width: 10.0),
                                Expanded(child: Text(subjectProvider.subjectList[index].name)),
                              ],
                            ),
                          );
                        },
                      ),
                      kSpace(),
                      Center(
                        child: updateData != true ? KButton(
                          title: 'Save',
                          onClick: (){
                            if(_formKey.currentState!.validate()){
                              if(courseValue == ''){
                                toastMessage(message: 'Select Course', colors: kRedColor);
                              } else if(semesterValue == ''){
                                toastMessage(message: 'Select Semester', colors: kRedColor);
                              } else if(selectedSubject.isEmpty){
                                toastMessage(message: 'Select Subject', colors: kRedColor);
                              } else {
                                saveSubjectGroup();
                              }
                            }
                            // toastMessage(message: 'Record Saved Successfully');
                          },
                        ) : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: KButton(
                                  title: 'Update',
                                  onClick: (){
                                    updateSubjectGroup();
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
                                      name.text = '';
                                      courseValue = '';
                                      semesterValue = '';
                                      oldSemesterValue = '';
                                      selectedSubject = [];
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
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: containerDesign(context),
              child: Column(
                children: [
                  Text('Subject Group List'.toUpperCase(), style: kHeaderStyle()),
                  kSpace(),
                  StreamBuilder(
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        var data = snapshot.data;
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index){
                            return Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: roundedContainerDesign(context).copyWith(
                                boxShadow: boxShadowDesign(),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  kRowText('Name: ', data[index]['name'].toString()),
                                  kRowText('Course Name: ', data[index]['course_name'].toString()),
                                  kRowText('Semester Name: ', data[index]['semester_name'].toString()),
                                  Text('Subject Name', style: kBoldStyle(),),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: data[index]['subject'].length,
                                    itemBuilder: (context, ind) {
                                      return Text(data[index]['subject'][ind]['name'].toString());
                                    }
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        onPressed: (){
                                          setState(() {
                                            name.text = '${data[index]['name']}';
                                            courseValue = '${data[index]['course_id']}';
                                            semesterValue = '${data[index]['semester_id']}';
                                            oldSemesterValue = '${data[index]['semester_id']}';
                                            // selectedSubject =
                                            for(var item in data[index]['subject']){
                                              selectedSubject.add('${item['subject_id']}');
                                            }
                                            updateData = true;
                                          });
                                        },
                                        child: Text('Edit'),
                                      ),
                                      TextButton(
                                        onPressed: (){
                                          deletePopUp(context,
                                            onClickYes: (){
                                              Navigator.pop(context);
                                              deleteSubjectGroup(
                                                courseID: '${data[index]['course_id']}',
                                                semesterID: '${data[index]['semester_id']}'
                                              );
                                            },
                                          );
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
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

  Future<String> deleteSubjectGroup({required String courseID,
    required String semesterID}) async {
    String url = APIData.deleteSubjectGroup;
    var response = await http.get(Uri.parse('$url/$courseID/$semesterID'),
      headers: APIData.kHeader,
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Item deleted');
      getSubjectGroup();
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  void updateSubjectGroup() async {
    List subjectList = [];
    for(var item in selectedSubject){
      subjectList.add({"id": item});
    }
    String url = APIData.updateSubjectGroup;
    var response = await http.post(Uri.parse(url), headers: APIData.kHeader,
      body: jsonEncode({
        "course_id": courseValue,
        "name": name.text,
        "old_semester": oldSemesterValue,
        "semester": semesterValue,
        "subject": subjectList,
      }),
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Subject Group Updated');
      setState(() {
        name.clear();
        courseValue = '';
        semesterValue = '';
        selectedSubject = [];
        updateData = false;
      });
      getSubjectGroup();
    } else {
      print(response.statusCode);
    }
  }
}
