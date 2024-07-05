import 'dart:async';
import 'dart:convert';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/model/semester_model.dart';
import 'package:medical_college/provider/course_provider.dart';
import 'package:medical_college/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SemesterTimeTable extends StatefulWidget {
  const SemesterTimeTable({super.key});

  @override
  State<SemesterTimeTable> createState() => _SemesterTimeTableState();
}

class _SemesterTimeTableState extends State<SemesterTimeTable> {

  final StreamController _streamController = StreamController();
  List<Semester> semesterList = [];
  String courseValue = '';
  String semesterValue = '';
  String sessionValue = '';
  bool searched = false;

  Future<void> getSemesterTimeTable() async {
    String url = '${APIData.getSemesterTimeTableByCourseAndSemesterId}/$courseValue/$semesterValue/$sessionValue';
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader,);
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      _streamController.add(jsonData['data']);
      setState(() {});
    } else {
      print(response.statusCode);
      print(response.body);
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
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Semester Timetable'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                decoration: roundedContainerDesign(context),
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
                    SizedBox(height: 10.0),
                    KButton(
                      title: 'Search',
                      onClick: (){
                        if (courseValue.isEmpty) {
                          toastMessage(message: 'Select the course', colors: kRedColor);
                        } else if (semesterValue.isEmpty) {
                          toastMessage(message: 'Select the semester', colors: kRedColor);
                        } else if (sessionValue.isEmpty) {
                          toastMessage(message: 'Select the session', colors: kRedColor);
                        } else {
                          setState(() {
                            searched = true;
                          });
                          getSemesterTimeTable();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            if(searched == true)
            StreamBuilder(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  var semesterTimeTableList = snapshot.data;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: roundedShadedDesign(context),
                      child: semesterTimeTableList.isNotEmpty ? ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: semesterTimeTableList.length,
                        itemBuilder: (context, index) {
                          String middleName = semesterTimeTableList[index]['teacher_middle_name'] != null &&
                              semesterTimeTableList[index]['teacher_middle_name'] != ''
                              ? '${semesterTimeTableList[index]['teacher_middle_name']} ': '';
                          return Column(
                            children: [
                              kIconTextDesign(
                                  iconData: Icons.person_outline,
                                  title: 'Teacher',
                                  desc: '${semesterTimeTableList[index]['teacher_first_name']} $middleName${semesterTimeTableList[index]['teacher_last_name']}'
                              ),
                              kIconTextDesign(
                                iconData: Icons.school_outlined,
                                title: 'Subject Name',
                                desc: '${semesterTimeTableList[index]['subject_name']}',
                              ),
                              kIconTextDesign(
                                iconData: Icons.school_outlined,
                                title: 'Course Name',
                                desc: '${semesterTimeTableList[index]['course_name']}',
                              ),
                              kIconTextDesign(
                                iconData: Icons.watch_later_outlined,
                                title: 'Time From',
                                desc: '${semesterTimeTableList[index]['time_from']}',
                              ),
                              kIconTextDesign(
                                iconData: Icons.watch_later_outlined,
                                title: 'Time To',
                                desc: '${semesterTimeTableList[index]['time_to']}',
                              ),
                              kRowText('Room Number: ', '${semesterTimeTableList[index]['room_no']}'),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return kDivider();
                        },
                      ) : Text('No Time Table Found'),
                    ),
                  );
                }
                return LoadingIcon();
              }
            ),
          ],
        ),
      ),
    );
  }
}
