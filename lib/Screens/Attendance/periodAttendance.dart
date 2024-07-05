import 'dart:async';
import 'dart:convert';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Screens/Attendance/attendance.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/model/attendance_model.dart';
import 'package:medical_college/model/semester_model.dart';
import 'package:medical_college/provider/course_provider.dart';
import 'package:medical_college/provider/session_provider.dart';
import 'package:medical_college/provider/subject_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PeriodAttendance extends StatefulWidget {
  const PeriodAttendance({super.key});

  @override
  State<PeriodAttendance> createState() => _PeriodAttendanceState();
}

class _PeriodAttendanceState extends State<PeriodAttendance> {

  final StreamController _streamController = StreamController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController date = TextEditingController();

  List<Semester> semesterList = [];
  String courseValue = '';
  String semesterValue = '';
  String subjectValue = '';
  String classValue = '';
  String sessionValue = '';
  bool isSearched = false;

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        date.text = '${picked.year}-${picked.month}-${picked.day}';
      });
    }
  }

  List<AttendanceModel> studentAttendanceList = [];
  Future<String> getAttendance() async {
    String url = APIData.getStudentAttendance;
    var response = await http.get(Uri.parse('$url/$courseValue/$semesterValue/${date.text}/$subjectValue/$sessionValue/$classValue'),
      headers: APIData.kHeader,
    );
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);

      studentAttendanceList = (jsonData['data'] as List)
          .map((itemJson) => AttendanceModel.fromJson(itemJson))
          .toList();

      _streamController.add(jsonData['data']);
      print(jsonData);
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  List<String> classList = ['new'];
  Future<String> getClass() async {
    classList = ['new'];
    String url = APIData.getClass;
    var response = await http.get(Uri.parse('$url/$subjectValue'),
      headers: APIData.kHeader,
    );
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      for(var item in jsonData['data']){
        classList.add(item['class'].toString());
      }
      setState(() {});
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
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final subjectProvider = Provider.of<SubjectProvider>(context, listen: false);
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Period Attendance'),
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
                    KTextField(
                      readOnly: true,
                      title: 'Date',
                      controller: date,
                      onClick: (){
                        _selectDate(context);
                      },
                      suffixButton: IconButton(
                        onPressed: (){
                          _selectDate(context);
                        },
                        icon: Icon(Icons.calendar_month_outlined),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text('Subject', style: kSmallText()),
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
                              value: subjectValue != '' ? subjectValue : null,
                              hint: Text('Subject'),
                              items: subjectProvider.subjectList
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.name),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  subjectValue = newValue!;
                                  getClass();
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
                        Text('Class', style: kSmallText()),
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
                              value: classValue != '' ? classValue : null,
                              hint: Text('Class'),
                              items: classList
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value.toString(),
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  classValue = newValue!;
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
                    SizedBox(height: 5.0),
                    KButton(
                      title: 'Search',
                      onClick: (){
                        if(_formKey.currentState!.validate()){
                          if(courseValue != '' && semesterValue != ''){
                            if(subjectValue != ''){
                              if(sessionValue != ''){
                                getAttendance();
                                setState(() {
                                  isSearched = true;
                                });
                              } else {
                                toastMessage(message: 'Select Session', colors: kRedColor);
                              }
                            } else {
                              toastMessage(message: 'Select Subject', colors: kRedColor);
                            }
                          } else {
                            toastMessage(message: 'Select Course and Semester', colors: kRedColor);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            if(isSearched != false)
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: containerDesign(context),
              child: Column(
                children: [
                  Text('Student List', style: kHeaderStyle()),
                  SizedBox(height: 10.0),
                  // SearchTextField(),
                  SizedBox(height: 15.0),
                  StreamBuilder(
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        var data = snapshot.data;
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: studentAttendanceList.length,
                          itemBuilder: (context, index) {
                            String middleName = studentAttendanceList[index].middleName != '' ? '${studentAttendanceList[index].middleName} ' : '';
                            return Container(
                              decoration: roundedContainerDesign(context).copyWith(
                                boxShadow: boxShadowDesign(),
                              ),
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  kRowText('User id: ', studentAttendanceList[index].userID.toString()),
                                  kRowText('Name: ', '${studentAttendanceList[index].firstName} $middleName${studentAttendanceList[index].lastName}'),
                                  Text('Attendance', style: kBoldStyle()),
                                  Row(
                                    children: [
                                      radioButton(
                                        iconData: studentAttendanceList[index].attendance == 'present' ?
                                        Icons.radio_button_checked : Icons.radio_button_off_outlined,
                                        title: 'Present',
                                        onClick: (){
                                          setState(() {
                                            studentAttendanceList[index].attendance = 'present';
                                          });
                                        },
                                      ),
                                      radioButton(
                                        iconData: studentAttendanceList[index].attendance == 'late' ?
                                        Icons.radio_button_checked : Icons.radio_button_off_outlined,
                                        title: 'Late',
                                        onClick: (){
                                          setState(() {
                                            studentAttendanceList[index].attendance = 'late';
                                          });
                                        },
                                      ),
                                      radioButton(
                                        iconData: studentAttendanceList[index].attendance == 'absent' ?
                                        Icons.radio_button_checked : Icons.radio_button_off_outlined,
                                        title: 'Absent',
                                        onClick: (){
                                          setState(() {
                                            studentAttendanceList[index].attendance = 'absent';
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  radioButton(
                                    iconData: studentAttendanceList[index].attendance == 'half day' ?
                                    Icons.radio_button_checked : Icons.radio_button_off_outlined,
                                    title: 'Half day',
                                    onClick: (){
                                      setState(() {
                                        studentAttendanceList[index].attendance = 'half day';
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index){
                            return SizedBox(height: 10.0);
                          },
                        );
                      }
                      return LoadingIcon();
                    }
                  ),
                  kSpace(),
                  KButton(
                    title: 'Save Attendance',
                    onClick: (){
                      saveAttendance();
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

  Future<String> saveAttendance() async {
    List bodyList = [];
    for(var item in studentAttendanceList){
      bodyList.add({
        "_class": classValue,
        "attendance": item.attendance,
        "course_id": courseValue,
        "date": date.text,
        "first_name": item.firstName,
        "last_name": item.lastName,
        "middle_name": item.middleName,
        "semester_id": semesterValue,
        "session_id": sessionValue,
        "subject_id": subjectValue,
        "topic_name": 'test',
        "user_id": item.userID,
      });
    }
    String url = APIData.saveAttendance;
    var response = await http.post(Uri.parse(url), headers: APIData.kHeader,
      body: jsonEncode(bodyList),
    );
    if(response.statusCode == 200){
      getAttendance();
      toastMessage(message: 'Attendance Saved');
    } else {
      print(response.statusCode);
      print(response.body);
    }
    return 'Success';
  }
}
