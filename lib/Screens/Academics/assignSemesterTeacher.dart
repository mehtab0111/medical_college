import 'dart:async';
import 'dart:convert';
import 'package:medical_college/Components/DialougBox/deletePopUp.dart';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/model/semester_model.dart';
import 'package:medical_college/provider/course_provider.dart';
import 'package:medical_college/provider/semester_provider.dart';
import 'package:medical_college/provider/teacher_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AssignSemesterTeacher extends StatefulWidget {
  const AssignSemesterTeacher({super.key});

  @override
  State<AssignSemesterTeacher> createState() => _AssignSemesterTeacherState();
}

class _AssignSemesterTeacherState extends State<AssignSemesterTeacher> {

  final StreamController _streamController = StreamController();
  final ScrollController _scrollController = ScrollController();
  // List<Semester> semesterList = [];
  String courseValue = '';
  String semesterValue = '';
  List<String> selectedTeacher = [];
  bool updateData = false;

  @override
  void initState() {
    super.initState();
    getAssignedSemesterTeacher();
  }

  Future<String> getAssignedSemesterTeacher() async {
    String url = APIData.getAssignedSemesterTeacher;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader);
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      _streamController.add(jsonData['data']);
    }
    else {
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
    final semesterProvider = Provider.of<SemesterProvider>(context, listen: false);
    final teacherProvider = Provider.of<TeacherProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Semester Teacher'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
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
                                  // semesterList = courseProvider.courseList
                                  //     .firstWhere((course) => course.id.toString() == courseValue)
                                  //     .semester;
                                  // semesterValue = '';
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
                              items: semesterProvider.semesterList.map((value) {
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
                        Text('Semester Teacher', style: kSmallText()),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: teacherProvider.teacherList.length,
                      itemBuilder: (context, index){
                        String middleName = teacherProvider.teacherList[index].middleName != null &&
                            teacherProvider.teacherList[index].middleName != ''
                            ? '${teacherProvider.teacherList[index].middleName} ': '';
                        return ListTile(
                          dense: true,
                          onTap: (){
                            if(selectedTeacher.contains(teacherProvider.teacherList[index].id.toString())) {
                              setState(() {
                                selectedTeacher.remove(teacherProvider.teacherList[index].id.toString());
                              });
                            } else {
                              setState(() {
                                selectedTeacher.add(teacherProvider.teacherList[index].id.toString());
                              });
                            }
                          },
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(selectedTeacher.contains(teacherProvider.teacherList[index].id.toString()) ?
                              Icons.check_box : Icons.check_box_outline_blank_outlined, color: kMainColor),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: Text('${teacherProvider.teacherList[index].firstName} '
                                    '$middleName${teacherProvider.teacherList[index].lastName}'
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10.0),
                    updateData != true ? KButton(
                      title: 'Save',
                      onClick: (){
                        if(!courseValue.isNotEmpty){
                          toastMessage(message: 'Select Course', colors: kRedColor);
                        } else if(!semesterValue.isNotEmpty){
                          toastMessage(message: 'Select Semester', colors: kRedColor);
                        } else {
                          updateSemesterTeacher();
                          // toastMessage(message: 'Record Saved Successfully');
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
                                updateSemesterTeacher();
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
                                  courseValue = '';
                                  semesterValue = '';
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10.0),
                    decoration: containerDesign(context),
                    child: Column(
                      children: [
                        Text('Semester Teacher List', style: kHeaderStyle()),
                        // SearchTextField(),
                      ],
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: _streamController.stream,
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      var data = snapshot.data;
                      return data.isNotEmpty ? ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index){
                          return Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: roundedContainerDesign(context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                kIconTextDesign(
                                  iconData: Icons.school_outlined,
                                  title: 'Course',
                                  desc: '${data[index]['course_name']}',
                                ),
                                kIconTextDesign(
                                  iconData: Icons.school_outlined,
                                  title: 'Semester',
                                  desc: '${data[index]['semester_name']}',
                                ),
                                Text('Semester Teacher: ', style: kBoldStyle()),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: data[index]['teacher'].length,
                                  itemBuilder: (context, ind){
                                    var teacher = data[index]['teacher'][ind];
                                    String middleName = teacher['middle_name'] != null ? '${teacher['middle_name']} ' : '';
                                    return Text('${teacher['first_name']} $middleName${teacher['last_name']}');
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: (){
                                        setState(() {
                                          updateData = true;
                                          courseValue = '${data[index]['course_id']}';
                                          semesterValue = '${data[index]['semester_id']}';
                                          for(var item in data[index]['teacher']){
                                            selectedTeacher.add(item['id'].toString());
                                          }
                                          _scrollController.jumpTo(0);
                                        });
                                      },
                                      child: Text('Edit'),
                                    ),
                                    TextButton(
                                      onPressed: (){
                                        deletePopUp(context, onClickYes: (){
                                          deleteTeachersAssign(
                                            courseID: '${data[index]['course_id']}',
                                            semesterID: '${data[index]['semester_id']}'
                                          );
                                          Navigator.pop(context);
                                        });
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
                          return SizedBox(height: 10.0);
                        },
                      ) : Text('No Teacher Assigned');
                    }
                    return CircularProgressIndicator();
                  }
                ),
                kSpace(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String> updateSemesterTeacher() async {

    List teacherList = [];
    for(var item in selectedTeacher){
      teacherList.add({
        'id': item,
      });
    }

    String url = APIData.updateSemesterTeacher;
    var response = await http.post(Uri.parse(url), headers: APIData.kHeader,
      body: jsonEncode({
        "course_id": courseValue,
        "semester_id": semesterValue,
        "teacher": teacherList,
      }),
    );
    if(response.statusCode == 200){
      // var jsonData = jsonDecode(response.body);
      toastMessage(message: 'Semester assigned to teacher');
      getAssignedSemesterTeacher();
      updateData = false;
      courseValue = '';
      semesterValue = '';
      selectedTeacher = [];
      setState(() {});
      // print(jsonData);
    }
    else {
      print(response.statusCode);
    }
    return 'Success';
  }

  Future<String> deleteTeachersAssign({required String courseID, required String semesterID}) async {
    String url = APIData.deleteTeachersAssign;
    var response = await http.get(Uri.parse('$url/$courseID/$semesterID'),
        headers: APIData.kHeader);
    if(response.statusCode == 200){
      toastMessage(message: 'Assign teacher deleted');
      getAssignedSemesterTeacher();
    }
    else {
      print(response.statusCode);
    }
    return 'Success';
  }
}
