import 'dart:convert';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/model/semester_model.dart';
import 'package:medical_college/provider/course_provider.dart';
import 'package:medical_college/provider/session_provider.dart';
import 'package:medical_college/provider/subject_provider.dart';
import 'package:medical_college/provider/teacher_provider.dart';
import 'package:medical_college/provider/week_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CreateSemesterTable extends StatefulWidget {
  const CreateSemesterTable({super.key});

  @override
  State<CreateSemesterTable> createState() => _CreateSemesterTableState();
}

class _CreateSemesterTableState extends State<CreateSemesterTable> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController fromTime = TextEditingController();
  TextEditingController toTime = TextEditingController();
  TextEditingController roomNo = TextEditingController();

  List<Semester> semesterList = [];
  String courseValue = '';
  String semesterValue = '';
  String sessionValue = '';
  String subjectValue = '';
  String subjectName = '';
  String teacherValue = '';
  String teacherName = '';
  String weekValue = '';
  String weekName = '';
  bool isLoading = false;

  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  Future<void> _selectTime(BuildContext context, int type) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
    );
    if (pickedTime != null) {
      if (type == 1) {
        selectedStartTime = pickedTime;
        fromTime.text = _formatTime(selectedStartTime);
      } else if (type == 2) {
        selectedEndTime = pickedTime;
        toTime.text = _formatTime(selectedEndTime);
      }
      setState(() {});
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.Hm();
    return format.format(dt);
  }

  // List<FranchiseModel> franchiseList = [];
  Future<String> getWeeks() async {
    String url = APIData.getFranchise;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader);
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      for(var item in jsonData['data']){
        print(item);
      }
      // print(jsonData);
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final teacherProvider = Provider.of<TeacherProvider>(context, listen: false);
    final subjectProvider = Provider.of<SubjectProvider>(context, listen: false);
    final weekProvider = Provider.of<WeekProvider>(context, listen: false);
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Semester Time Table'),
      ),
      body: SingleChildScrollView(
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
                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
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
                      kDivider(),
                      Row(
                        children: [
                          SizedBox(width: 10.0),
                          Text('Select Subject', style: kSmallText()),
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
                                hint: Text('Select Subject'),
                                items: subjectProvider.subjectList.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value.id.toString(),
                                    child: Text(value.name),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    subjectValue = newValue!;
                                    subjectName = subjectProvider.subjectList
                                        .firstWhere((subject) => subject.id.toString() == newValue)
                                        .name;
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
                          Text('Teacher List', style: kSmallText()),
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
                                value: teacherValue != '' ? teacherValue : null,
                                hint: Text('Teacher List'),
                                items: teacherProvider.teacherList.map((value) {
                                  String middleName = value.middleName != '' ? '${value.middleName} ' : '';
                                  return DropdownMenuItem<String>(
                                    value: value.id.toString(),
                                    child: Text('${value.firstName} $middleName${value.lastName}'),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    teacherValue = newValue!;
                                    String firstName = teacherProvider.teacherList
                                        .firstWhere((subject) => subject.id.toString() == newValue)
                                        .firstName;
                                    String middleName = teacherProvider.teacherList
                                        .firstWhere((subject) => subject.id.toString() == newValue)
                                        .middleName;
                                    String lastName = teacherProvider.teacherList
                                        .firstWhere((subject) => subject.id.toString() == newValue)
                                        .lastName;

                                    teacherName = '$firstName $middleName $lastName';
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      KTextField(
                        readOnly: true,
                        title: 'Time From',
                        controller: fromTime,
                        onClick: (){
                          _selectTime(context, 1);
                        },
                        suffixButton: Icon(Icons.schedule_outlined,
                          color: kMainColor,
                        ),
                      ),
                      KTextField(
                        readOnly: true,
                        title: 'Time To',
                        controller: toTime,
                        onClick: (){
                          _selectTime(context, 2);
                        },
                        suffixButton: Icon(Icons.schedule_outlined,
                          color: kMainColor,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10.0),
                          Text('Select Day', style: kSmallText()),
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
                                value: weekValue != '' ? weekValue : null,
                                hint: Text('Select Day'),
                                items: weekProvider.weekList.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value.id.toString(),
                                    child: Text(value.name),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    weekValue = newValue!;
                                    weekName = weekProvider.weekList
                                        .firstWhere((item) => item.id.toString() == newValue)
                                        .name;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      KTextField(title: 'Room No', controller: roomNo,),
                      SizedBox(height: 10),
                      isLoading != true ? KButton(
                        title: 'Add',
                        onClick: (){
                          if(_formKey.currentState!.validate()){
                            if(courseValue == ''){
                              toastMessage(message: 'Select Course', colors: kRedColor);
                            } else if(semesterValue == ''){
                              toastMessage(message: 'Select Semester', colors: kRedColor);
                            } else if(subjectValue == ''){
                              toastMessage(message: 'Select Subject', colors: kRedColor);
                            } else if(teacherValue == ''){
                              toastMessage(message: 'Select Teacher', colors: kRedColor);
                            } else if(weekValue == ''){
                              toastMessage(message: 'Select Day', colors: kRedColor);
                            } else {
                              saveSemesterTimeTable(context);
                            }
                          }
                        },
                      ) : LoadingButton(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> saveSemesterTimeTable(context) async {
    print(subjectName);
    print(teacherName);
    setState(() {
      isLoading = true;
    });
    String url = APIData.saveSemesterTimeTable;
    var response = await http.post(Uri.parse(url), headers: APIData.kHeader,
      body: jsonEncode({
        "course_id": courseValue,
        "semester_id": semesterValue,
        "session_id": sessionValue,
        "details": [
          {
            "week_id": weekValue,
            "week_name": weekName,
            "subject_id": subjectValue,
            "subject_name": subjectName,
            "teacher_id": teacherValue,
            "teacher_name": teacherName,
            "room_no": roomNo.text,
            "time_from": fromTime.text,
            "time_to": toTime.text,
          }
        ]
      }),
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Semester Time Table Saved');
      Navigator.pop(context);
    } else {
      print(response.statusCode);
      toastMessage(message: 'Error while creating table (${response.statusCode})', colors: kRedColor);
      setState(() {
        isLoading = false;
      });
    }
    return 'Success';
  }
}
