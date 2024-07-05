import 'dart:convert';

import 'package:medical_college/Screens/Home/studentDashboard.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/faceDetectionScreen.dart';
import 'package:medical_college/staffFaceAttendance.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    getDashboard();
  }

  String totalStudent = '0';
  String totalTeacher = '0';
  String totalExpense = '0';
  String totalFeesReceived = '0';
  Future<String> getDashboard() async {
    String url = APIData.dashboard;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader);
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      // print(jsonData);
      totalStudent = jsonData['data']['total_student'].toString();
      totalTeacher = jsonData['data']['total_teacher'].toString();
      totalExpense = jsonData['data']['total_expense'].toString();
      totalFeesReceived = jsonData['data']['total_fees_received'].toString();
      setState(() {});
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Dashboard'),
      //   actions: [
      //     MaterialButton(
      //       color: kButtonColor,
      //       textColor: kBTextColor,
      //       shape: materialButtonDesign(),
      //       onPressed: (){
      //         Navigator.push(context, MaterialPageRoute(
      //             builder: (context) => StaffFaceAttendance()));
      //       },
      //       child: Text('Staff Attendance'),
      //     ),
      //     SizedBox(width: 10),
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StudentDashBoard(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                decoration: roundedContainerDesign(context),
                child: Column(
                  children: [
                    kRowIconText(
                      iconData: Icons.currency_rupee_outlined,
                      title: 'Fees Awaiting Payment',
                      desc: '0/0',
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: LinearProgressIndicator(
                        value: 0.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                decoration: roundedContainerDesign(context),
                child: Column(
                  children: [
                    kRowIconText(
                      iconData: Icons.event_available_outlined,
                      title: 'Staff Present Today',
                      desc: '0/54',
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: LinearProgressIndicator(
                        value: 0.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                decoration: roundedContainerDesign(context).copyWith(
                  color: k3Color
                ),
                child: Column(
                  children: [
                    kRowIconText(
                      iconData: Icons.currency_rupee_outlined,
                      title: 'Fees Overview',
                      textBackColor: kWhiteColor,
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          kWhiteRowText('0 UnPaid', '0%'),
                          kWhiteRowText('0 Partial', '0%'),
                          kWhiteRowText('0 Paid', '0%'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                decoration: roundedContainerDesign(context).copyWith(
                  color: k4Color
                ),
                child: Column(
                  children: [
                    kRowIconText(
                      iconData: Icons.library_books_outlined,
                      title: 'Library Overview',
                      textBackColor: kWhiteColor,
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          kWhiteRowText('0 DUE FOR RETURN', ''),
                          kWhiteRowText('0 RETURNED', ''),
                          kWhiteRowText('ISSUED OUT OF', '0%'),
                          kWhiteRowText('0 AVAILABLE OUT OF', '0%'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                decoration: roundedContainerDesign(context).copyWith(
                  color: k5Color
                ),
                child: Column(
                  children: [
                    kRowIconText(
                      iconData: Icons.front_hand_outlined,
                      title: 'Student Today Attendance',
                      textBackColor: kWhiteColor,
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          kWhiteRowText('Present', ''),
                          kWhiteRowText('Late', ''),
                          kWhiteRowText('Absent', ''),
                          kWhiteRowText('Half Day', ''),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            kColumnIconText(context,
              iconData: Icons.currency_rupee_outlined,
              title: 'Monthly Fees Collection',
              desc: totalFeesReceived,
              textBackColor: kWhiteColor,
            ),
            kColumnIconText(context,
              iconData: Icons.credit_card_outlined,
              title: 'Monthly Expenses',
              desc: totalExpense,
              textBackColor: kWhiteColor,
            ),
            kColumnIconText(context,
              iconData: Icons.person_outline_outlined,
              title: 'Student',
              desc: totalStudent,
              textBackColor: kWhiteColor,
            ),
            kColumnIconText(context,
              iconData: Icons.person_outline_outlined,
              title: 'Teacher',
              desc: totalTeacher,
              textBackColor: kWhiteColor,
            ),
            kColumnIconText(context,
              iconData: Icons.person_outline_outlined,
              title: 'Accountant',
              desc: '1',
              textBackColor: kWhiteColor,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit_calendar_outlined),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => FaceDetectionScreen()));
        },
      ),
    );
  }
}

Row kRowIconText({required IconData iconData,
  required String title,
  String? desc,
  Color? textBackColor}) {
  return Row(
    children: [
      Container(
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            color: kMainColor,
            borderRadius: BorderRadius.horizontal(
              right: Radius.circular(30.0),
            )
        ),
        child: Icon(iconData, color: kWhiteColor),
      ),
      SizedBox(width: 10.0),
      Text(title, style: kHeaderStyle().copyWith(color: textBackColor)),
      Spacer(),
      Text(desc ?? '', style: kHeaderStyle().copyWith(color: textBackColor)),
      SizedBox(width: 10.0),
    ],
  );
}

Widget kColumnIconText(context, {required IconData iconData,
  required String title,
  String? desc,
  Color? textBackColor}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      decoration: roundedContainerDesign(context).copyWith(
          color: k4Color
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                color: kMainColor,
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(30.0),
                )
            ),
            child: Icon(iconData, color: kWhiteColor),
          ),
          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: kHeaderStyle().copyWith(color: textBackColor)),
              Text(desc ?? '', style: kHeaderStyle().copyWith(color: textBackColor)),
            ],
          ),
          SizedBox(width: 10.0),
        ],
      ),
    ),
  );
}
