import 'dart:async';
import 'dart:convert';
import 'package:medical_college/Components/localDatabase.dart';
import 'package:medical_college/provider/student_provider.dart';
import 'package:http/http.dart' as http;
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Screens/emptyScreen.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/provider/course_provider.dart';
import 'package:medical_college/provider/semester_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeesDueReport extends StatefulWidget {
  const FeesDueReport({super.key});

  @override
  State<FeesDueReport> createState() => _FeesDueReportState();
}

class _FeesDueReportState extends State<FeesDueReport> {

  final StreamController _streamController = StreamController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();

  String courseValue = '';
  String semesterValue = '';
  String studentValue = '';
  bool isSearched = false;

  void getDueFeesReport() async {
    String url = APIData.getDueFeesReport;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader);
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
    final studentProvider = Provider.of<StudentProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Fees Due Report'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: containerDesign(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text('Select Criteria', style: kHeaderStyle()),
                  ),
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
                    child: Text('Student', style: kSmallText()),
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
                            .where((item) => item.courseId.toString() == courseValue)
                            .where((item) => item.semesterId.toString() == semesterValue)
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value.id.toString(),
                                child: Text('${value.firstName} ${value.lastName}'),
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
                  SizedBox(height: 5.0),
                  Center(
                    child: KButton(
                      title: 'Search',
                      onClick: (){
                        if(courseValue == ''){
                          toastMessage(message: 'Select Course', colors: kRedColor);
                        } else if(semesterValue == ''){
                          toastMessage(message: 'Select Semester', colors: kRedColor);
                        } else {
                          getDueFeesReport();
                          setState(() {
                            isSearched = true;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            kSpace(),
            if(isSearched == true)
              Container (
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: containerDesign(context),
                child: Column(
                  children: [
                    Text('FEES DUE REPORT', style: kLargeStyle(),),
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
                                      kRowText('ID: ', '${data[index]['user_id']}'),
                                      kRowText('User Name: ', '${data[index]['user_name']}'),
                                      kRowText('Course: ', '${data[index]['course_name']}'),
                                      kRowText('Semester: ', '${data[index]['payment_details'][0]['name']} - Total => '
                                          '${data[index]['payment_details'][0]['amount']}\n'
                                          'Discount => ${data[index]['payment_details'][0]['discount']} '
                                          'Paid => ${data[index]['payment_details'][0]['total_paid']}'),
                                      kRowText('Book Fine: ', '${data[index]['book_fine']}'),
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
