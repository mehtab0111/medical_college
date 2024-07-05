import 'dart:async';
import 'dart:convert';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Screens/emptyScreen.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/provider/session_provider.dart';
import 'package:http/http.dart' as http;
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/provider/course_provider.dart';
import 'package:medical_college/provider/semester_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceReport extends StatefulWidget {
  const AttendanceReport({super.key});

  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {

  final StreamController _streamController = StreamController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();

  String courseValue = '';
  String semesterValue = '';
  String sessionValue = '';
  bool isSearched = false;

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context, int type) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      if(type == 1){
        setState(() {
          selectedDate = picked;
          fromDate.text = '${picked.year}-${picked.month}-${picked.day}';
        });
      } else {
        setState(() {
          selectedDate = picked;
          toDate.text = '${picked.year}-${picked.month}-${picked.day}';
        });
      }
    }
  }

  void getAttendancePercentage() async {
    String url = APIData.getAttendancePercentage;
    var response = await http.post(Uri.parse(url), headers: APIData.kHeader,
        body: jsonEncode({
          "course_id": courseValue,
          "from_date": fromDate.text,
          "semester_id": semesterValue,
          "session_id": sessionValue,
          "to_date": toDate.text,
        })
    );
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      _streamController.add(jsonData['data']);
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
    final semesterProvider = Provider.of<SemesterProvider>(context, listen: false);
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Report'),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text('Course', style: kSmallText()),
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
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.courseName),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  courseValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text('Semester', style: kSmallText()),
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
                              items: semesterProvider.semesterList
                                  .map<DropdownMenuItem<String>>((value) {
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
                      child: Text('Session', style: kSmallText()),
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
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.name),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  sessionValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('From Date', style: kSmallText()),
                    ),
                    KTextField(
                      readOnly: true,
                      title: 'From Date',
                      controller: fromDate,
                      onClick: (){
                        _selectDate(context, 1);
                      },
                      suffixButton: IconButton(
                        onPressed: (){
                          _selectDate(context, 1);
                        },
                        icon: Icon(Icons.calendar_month_outlined),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('To Date', style: kSmallText()),
                    ),
                    KTextField(
                      readOnly: true,
                      title: 'To Date',
                      controller: toDate,
                      onClick: (){
                        _selectDate(context, 2);
                      },
                      suffixButton: IconButton(
                        onPressed: (){
                          _selectDate(context, 2);
                        },
                        icon: Icon(Icons.calendar_month_outlined),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Center(
                      child: KButton(
                        title: 'Save',
                        onClick: (){
                          if(_formKey.currentState!.validate()){
                            if(courseValue == ''){
                              toastMessage(message: 'Select Course', colors: kRedColor);
                            } else if(semesterValue == ''){
                              toastMessage(message: 'Select Semester', colors: kRedColor);
                            } else if(sessionValue == ''){
                              toastMessage(message: 'Select Session', colors: kRedColor);
                            } else {
                              getAttendancePercentage();
                              setState(() {
                                isSearched = true;
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            kSpace(),
            if(isSearched == true)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: containerDesign(context),
                child: Column(
                  children: [
                    Text('Student Admission Report', style: kLargeStyle(),),
                    kSpace(),
                    StreamBuilder(
                        stream: _streamController.stream,
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            var data = snapshot.data;
                            return data.isNotEmpty ? ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: data.length,
                              itemBuilder: (context, index){
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: roundedShadedDesign(context),
                                  child: Column(
                                    children: [
                                      // kRowText('ID: ', '${data[index]['id']}'),
                                      kRowText('Name: ', '${data[index]['name']}'),
                                      kRowText('Total Class: ', '${data[index]['total_classes']}'),
                                      kRowText('Present: ', '${data[index]['present']}'),
                                      kRowText('Absent: ', '${data[index]['absent']}'),
                                      kRowText('Percentage	: ', '${data[index]['attendance_percentage']}%'),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return kSpace();
                              },
                            ) : EmptyScreen(message: 'No Data Found');
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
}
