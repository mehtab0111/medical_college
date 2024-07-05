import 'dart:convert';
import 'package:medical_college/Components/DialougBox/popup.dart';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/model/semester_model.dart';
import 'package:medical_college/model/student_model.dart';
import 'package:medical_college/provider/course_provider.dart';
import 'package:medical_college/provider/semester_provider.dart';
import 'package:medical_college/provider/session_provider.dart';
import 'package:medical_college/provider/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PromoteStudent extends StatefulWidget {
  const PromoteStudent({super.key});

  @override
  State<PromoteStudent> createState() => _PromoteStudentState();
}

class _PromoteStudentState extends State<PromoteStudent> {

  List<Semester> semesterList = [];
  String courseValue = '';
  String semesterValue = '';
  String sessionValue = '';
  String promoteSessionValue = '';
  String promotedSemesterValue = '';
  List<Student> promoteStudent = [];

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final semesterProvider = Provider.of<SemesterProvider>(context, listen: false);
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final studentProvider = Provider.of<StudentProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Promote Student'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: roundedContainerDesign(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Criteria', style: kHeaderStyle()),
                    Text('Course', style: kSmallText()),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
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
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
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
                              items: semesterList.map((value) {
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
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text('Session', style: kSmallText()),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: dropTextFieldDesign(),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(10.0),
                              value: sessionValue != '' ? sessionValue : null,
                              hint: Text('Session'),
                              items: sessionProvider.sessionList
                                  .map((value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.name),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                print(newValue);
                                setState(() {
                                  sessionValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text('Promote Students In Next Session', style: kHeaderStyle()),
                    Text('Promote To Semester', style: kSmallText()),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: dropTextFieldDesign(),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(10.0),
                              value: promotedSemesterValue != '' ? promotedSemesterValue : null,
                              hint: Text('Semester'),
                              items: semesterProvider.semesterList
                                  .map((value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.name),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  promotedSemesterValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text('Session', style: kSmallText()),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
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
                              value: promoteSessionValue != '' ? promoteSessionValue : null,
                              hint: Text('Promote In Session'),
                              items: sessionProvider.sessionList.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.name),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  promoteSessionValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Center(
                      child: KButton(
                        title: 'Search',
                        onClick: (){
                          if (courseValue == '') {
                            toastMessage(message: 'Select Course', colors: kRedColor);
                          } else if (semesterValue == '') {
                            toastMessage(message: 'Select Semester', colors: kRedColor);
                          } else if (sessionValue == '') {
                            toastMessage(message: 'Select Session', colors: kRedColor);
                          } else if(promotedSemesterValue == ''){
                            toastMessage(message: 'Select Promote Semester', colors: kRedColor);
                          } else if(promoteSessionValue == ''){
                            toastMessage(message: 'Select Promote Session', colors: kRedColor);
                          } else {
                            setState(() {
                              promoteStudent = studentProvider.studentList.where((item) {
                                return item.courseId.toString() == courseValue &&
                                    item.semesterId.toString() == semesterValue &&
                                    item.sessionId.toString() == sessionValue;
                              }).toList();

                              if (promoteStudent.isEmpty) {
                                print('No students found matching the criteria.');
                              } else {
                                for(var item in promoteStudent){
                                  print('Promoted Students: ${item.image}');
                                }
                                print('Promoted Students: ${promoteStudent[0].image}');
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ],
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
                  Text('Student List'.toUpperCase(), style: kHeaderStyle()),
                  promoteStudent.isNotEmpty ?
                  ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: promoteStudent.length,
                    itemBuilder: (context, index){
                      String middleName = promoteStudent[index].middleName != '' ? '${promoteStudent[index].middleName} ' : '';

                      // var data = studentProvider.studentList.where((item) => item.lastName == '').toList();
                      return ListTile(
                        onTap: (){
                          if(selectedStudents.contains(promoteStudent[index].id)){
                            setState(() {
                              selectedStudents.remove(promoteStudent[index].id);
                            });
                          } else {
                            setState(() {
                              selectedStudents.add(promoteStudent[index].id);
                            });
                          }
                        },
                        leading: Icon(selectedStudents.contains(promoteStudent[index].id) ?
                        Icons.check_box :
                        Icons.check_box_outline_blank),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // if(promoteStudent[index].image != '')
                            // Image.network(promoteStudent[index].imageURL + promoteStudent[index].image, height: 100),
                            // Text(promoteStudent[index].imageURL + promoteStudent[index].image),
                            kRowText('Name: ', '${promoteStudent[index].firstName} $middleName${promoteStudent[index].lastName}'),
                            kRowText('Date Of Birth: ', promoteStudent[index].dob),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                  ) : Text('No Student Found'),
                  if(promoteStudent.isNotEmpty)
                  KButton(
                    title: 'Promote',
                    onClick: (){
                      kPopUp(context,
                        title: 'Promote Confirmation',
                        desc: 'Are you sure you want to promote?',
                        onClickYes: (){
                          promoteStudents();
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List selectedStudents = [];
  Future<String> promoteStudents() async {
    List promoteStudentList = [];
    for(var item in selectedStudents){
      promoteStudentList.add({
        "id": item.toString(),
        "promote_semester_id": promotedSemesterValue,
        "promote_session_id": promoteSessionValue
      });
    }
    print(promoteStudentList);
    String url = APIData.promoteStudents;
    var response = await http.post(Uri.parse(url), headers: APIData.kHeader,
      body: jsonEncode(promoteStudentList),
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Promoted Successfully');
      setState(() {
        selectedStudents = [];
        promoteStudent = [];
      });
    } else {
      print(response.statusCode);
      print(response.body);
    }
    return 'Success';
  }
}
