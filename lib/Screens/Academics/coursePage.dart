import 'dart:async';
import 'dart:convert';
import 'package:medical_college/Components/DialougBox/deletePopUp.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:http/http.dart' as http;
import 'package:medical_college/Components/buttons.dart';
// import 'package:medical_college/Components/localDatabase.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/provider/semester_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {

  final StreamController _streamController = StreamController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController courseName = TextEditingController();

  String courseID = '';
  String courseDuration = '';
  List<String> semesterListValue = [];
  bool updateData = false;

  @override
  void initState() {
    super.initState();
    getCourse();
  }

  void getCourse() async {
    String url = APIData.getCourse;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader,);
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      _streamController.add(jsonData['data']);
    } else {
      print(response.statusCode);
    }
  }

  void saveCourse() async {
    List semesterList = [];
    for(var item in semesterListValue){
      setState(() {
        semesterList.add({'semester_id': item});
      });
    }
    String url = APIData.saveCourse;
    var response = await http.post(Uri.parse(url),
      headers: APIData.kHeader,
      body: jsonEncode({
        "course_name": courseName.text,
        "duration": 1,
        "semester": semesterList,
      }),
    );
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      courseName.clear();
      semesterListValue = [];
      setState(() {});
      toastMessage(message: 'Course Added');
      getCourse();
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
    final semesterProvider = Provider.of<SemesterProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Course'),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text('Add Course', style: kHeaderStyle()),
                      ),
                      KTextField(title: 'Course', controller: courseName,),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text('Semester', style: kBoldStyle()),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: semesterProvider.semesterList.length,
                        itemBuilder: (context, index){
                          return InkWell(
                            onTap: (){
                              if(semesterListValue.contains(semesterProvider.semesterList[index].id.toString())){
                                setState(() {
                                  semesterListValue.remove(semesterProvider.semesterList[index].id.toString());
                                });
                              } else {
                                setState(() {
                                  semesterListValue.add(semesterProvider.semesterList[index].id.toString());
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Icon(semesterListValue.contains(semesterProvider.semesterList[index].id.toString()) ?
                                Icons.check_box : Icons.check_box_outline_blank_outlined),
                                SizedBox(width: 10.0),
                                Text(semesterProvider.semesterList[index].name),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10.0),
                      Center(
                        child: updateData != true ? KButton(
                          title: 'Save',
                          onClick: (){
                            if(_formKey.currentState!.validate()){
                              saveCourse();
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
                                    updateCourse();
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
                                      courseName.text = '';
                                      semesterListValue.clear();
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
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              decoration: containerDesign(context),
              child: Column(
                children: [
                  Text('Course List', style: kHeaderStyle()),
                  StreamBuilder(
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        var data = snapshot.data;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index){
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                decoration: roundedContainerDesign(context).copyWith(
                                  boxShadow: boxShadowDesign(),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10.0),
                                    kRowText('Course: ', data[index]['course_name'].toString()),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Semester: ', style: kBoldStyle()),
                                        Expanded(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: data[index]['semester'].length,
                                            itemBuilder: (context, ind){
                                              var semester = data[index]['semester'][ind];
                                              return Text(semester['name'].toString());
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          onPressed: (){
                                            print(data[index]);
                                            setState(() {
                                              courseID = '${data[index]['id']}';
                                              courseDuration = '${data[index]['duration']}';
                                              courseName.text = '${data[index]['course_name']}';
                                              for(var item in data[index]['semester']){
                                                semesterListValue.add(item['id'].toString());
                                              }
                                              updateData = true;
                                            });
                                          },
                                          child: Text('Edit'),
                                        ),
                                        TextButton(
                                          onPressed: (){
                                            deletePopUp(context, onClickYes: (){
                                              deleteCourse('${data[index]['id']}');
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return LoadingIcon();
                    }
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void deleteCourse(String courseID) async {
    String url = APIData.deleteCourse;
    var response = await http.get(Uri.parse('$url/$courseID'),
      headers: APIData.kHeader,);
    if(response.statusCode == 200){
      toastMessage(message: 'Course Deleted');
      getCourse();
    } else {
      print(response.statusCode);
    }
  }

  void updateCourse() async {
    List semesterList = [];
    for(var item in semesterListValue){
      setState(() {
        semesterList.add({'semester_id': item});
      });
    }
    String url = APIData.updateCourse;
    var response = await http.post(Uri.parse(url),
      headers: APIData.kHeader,
      body: jsonEncode({
        "id": courseID,
        "course_name": courseName.text,
        "duration": courseDuration,
        "semester": semesterList,
      }),
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Course Updated');
      setState(() {
        courseID = '';
        courseDuration = '';
        courseName.text = '';
        semesterListValue = [];
        updateData = false;
      });
      getCourse();
    } else {
      print(response.statusCode);
      setState(() {
        updateData = false;
      });
    }
  }
}
