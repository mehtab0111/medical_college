import 'dart:async';
import 'dart:convert';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/provider/teacher_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class TeacherTimetable extends StatefulWidget {
  const TeacherTimetable({super.key});

  @override
  State<TeacherTimetable> createState() => _TeacherTimetableState();
}

class _TeacherTimetableState extends State<TeacherTimetable> {

  final StreamController _streamController = StreamController();
  String teacherValue = '';
  bool searched = false;

  Future<void> getSemesterTimeTable() async {
    String url = '${APIData.getSemesterTimeTableByTeacherId}/$teacherValue';
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader);
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      _streamController.add(jsonData['data']);
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
    final teacherProvider = Provider.of<TeacherProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Timetable'),
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
                        Text('Teacher', style: kSmallText()),
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
                              hint: Text('Teacher'),
                              items: teacherProvider.teacherList
                                  .map((value) {
                                String middleName = '${value.middleName} ' ?? '';
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.firstName+ middleName + value.lastName),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  teacherValue = newValue!;
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
                        if (teacherValue.isEmpty) {
                          toastMessage(message: 'Select teacher', colors: kRedColor);
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
                                  iconData: Icons.school_outlined,
                                  title: 'Semester Name',
                                  desc: '${semesterTimeTableList[index]['semester_name']}',
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
                  return CircularProgressIndicator();
                }
              )
          ],
        ),
      ),
    );
  }
}
