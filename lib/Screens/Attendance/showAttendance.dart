import 'dart:async';
import 'dart:convert';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/localDatabase.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/model/semester_model.dart';
import 'package:medical_college/provider/course_provider.dart';
import 'package:medical_college/provider/session_provider.dart';
import 'package:medical_college/provider/student_provider.dart';
import 'package:medical_college/provider/subject_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ShowAttendance extends StatefulWidget {
  const ShowAttendance({super.key});

  @override
  State<ShowAttendance> createState() => _ShowAttendanceState();
}

class _ShowAttendanceState extends State<ShowAttendance> {

  final StreamController _streamController = StreamController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController date = TextEditingController();

  List<Semester> semesterList = [];
  String courseValue = '';
  String semesterValue = '';
  String studentValue = '';
  String sessionValue = '';
  bool markAsHoliday = false;

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
        date.text = '${picked.day}-${picked.month}-${picked.year}';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // getAttendance();
  }

  Future<String> getAttendance() async {
    String url = APIData.getStudentAttendance;
    // String url = APIData.getStudentOwnAttendance;
    var response = await http.get(Uri.parse('$url/$courseValue/$semesterValue/${date.text}/$studentValue/$sessionValue'),
      headers: APIData.kHeader,
    );
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      _streamController.add(jsonData['data']);
      print(jsonData);
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
    final studentProvider = Provider.of<StudentProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Attendance'),
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
                        Text('Student', style: kSmallText()),
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
                              value: studentValue != '' ? studentValue : null,
                              hint: Text('Student'),
                              items: studentProvider.studentList
                                  .where((student) => student.courseId.toString() == courseValue
                                  && student.semesterId.toString() == semesterValue)
                                  .map<DropdownMenuItem<String>>((value) {
                                    String middleName = value.middleName != '' ? '${value.middleName} ' : '';
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text('${value.firstName} $middleName${value.lastName}'),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  studentValue = newValue!;
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
                            if(studentValue != ''){
                              if(sessionValue != ''){
                                getAttendance();
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
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: studentList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: roundedContainerDesign(context).copyWith(
                                  boxShadow: boxShadowDesign(),
                                ),
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    kRowText('Admission No: ', studentList[index].admissionNo),
                                    kRowText('Roll No: ', studentList[index].admissionNo),
                                    kRowText('Name: ', studentList[index].studentName),
                                    Text('Attendance', style: kBoldStyle()),
                                    Row(
                                      children: [
                                        radioButton(
                                          iconData: Icons.radio_button_off_outlined,
                                          title: 'Present',
                                          onClick: (){},
                                        ),
                                        radioButton(
                                          iconData: Icons.radio_button_off_outlined,
                                          title: 'Late',
                                          onClick: (){},
                                        ),
                                        radioButton(
                                          iconData: Icons.radio_button_off_outlined,
                                          title: 'Absent',
                                          onClick: (){},
                                        ),
                                      ],
                                    ),
                                    radioButton(
                                      iconData: Icons.radio_button_off_outlined,
                                      title: 'Half day',
                                      onClick: (){},
                                    ),
                                    KTextField(title: 'Note'),
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
                  SizedBox(height: 15.0),
                  MaterialButton(
                    height: 45,
                    minWidth: MediaQuery.of(context).size.width*0.8,
                    shape: materialButtonDesign(),
                    color: k2MainColor,
                    textColor: kBTextColor,
                    onPressed: (){
                      setState(() {
                        markAsHoliday = !markAsHoliday;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(markAsHoliday != true ?
                        Icons.check_box_outline_blank_outlined : Icons.check_box),
                        SizedBox(width: 5.0),
                        Text('Mark As Holiday'),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  KButton(
                    title: 'Save Attendance',
                    onClick: (){},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

