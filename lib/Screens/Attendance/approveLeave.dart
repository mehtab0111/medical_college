import 'package:medical_college/Components/DialougBox/deletePopUp.dart';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/localDatabase.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Screens/Attendance/addLeave.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';

class ApproveLeave extends StatefulWidget {
  const ApproveLeave({super.key});

  @override
  State<ApproveLeave> createState() => _ApproveLeaveState();
}

class _ApproveLeaveState extends State<ApproveLeave> {

  String courseValue = '';
  String semesterValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Approve Leave'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: containerDesign(context),
              child: Column(
                children: [
                  Text('Select Criteria', style: kHeaderStyle()),
                  SizedBox(height: 10.0),
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
                            items: courseList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
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
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
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
                  SizedBox(height: 5.0),
                  KButton(
                    title: 'Search',
                    onClick: (){},
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: containerDesign(context),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Approve Leave List', style: kHeaderStyle()),
                      TextButton(
                        onPressed: (){
                          // showDialog<String>(
                          //   context: context,
                          //   builder: (BuildContext context) => AddLeave(),
                          // );
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddLeave()));
                        },
                        child: Text('+ Add'),
                      ),
                    ],
                  ),
                  SearchTextField(),
                  SizedBox(height: 10.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 2,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: roundedContainerDesign(context).copyWith(
                            boxShadow: boxShadowDesign(),
                          ),
                          child: Column(
                            children: [
                              kRowText('Student Name', 'desc'),
                              kRowText('Course', 'desc'),
                              kRowText('Semester', 'desc'),
                              kRowText('Apply Date: ', 'desc'),
                              kRowText('From Date: ', '1/8/23'),
                              kRowText('To Date: ', '31/8/23'),
                              kRowText('Status: ', 'Pending'),
                              kRowText('Approve by: ', 'Super-Admin'),
                              Row(
                                children: [
                                  Text('Action: ', style: kBoldStyle()),
                                  IconButton(onPressed: (){}, icon: Icon(Icons.check),),
                                  IconButton(onPressed: (){}, icon: Icon(Icons.edit_outlined),),
                                  IconButton(
                                    onPressed: (){
                                      deletePopUp(context,
                                        onClickYes: (){
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
