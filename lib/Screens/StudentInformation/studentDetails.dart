import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/localDatabase.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';

class StudentDetails extends StatefulWidget {
  const StudentDetails({super.key});

  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {

  TextEditingController search = TextEditingController();

  String courseValue = '';
  String semesterValue = '';
  bool searched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: containerDesign(context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Select Criteria', style: kHeaderStyle()),
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
                    onClick: (){
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: KTextField(title: 'Search By Keyword'),
                  ),
                  KButton(
                    title: 'Search',
                    onClick: (){
                      Navigator.pop(context);
                    },
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
                  Text('Student Details', style: kHeaderStyle()),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: SearchTextField(
                      controller: search,
                      onClear: (){
                        setState(() {
                          search.text = '';
                        });
                      },
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: studentList.length,
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
                              kRowText('Admission No: ', '${studentList[index].studentID}'),
                              kRowText('Student Name: ', studentList[index].studentName),
                              kRowText('Course: ', studentList[index].studentName),
                              kRowText('Fathers Name: ', studentList[index].fatherName),
                              kRowText('DOB: ', studentList[index].dob),
                              kRowText('Gender: ', studentList[index].studentName),
                              kRowText('Company: ', studentList[index].studentName),
                              kRowText('Mobile: ', studentList[index].mobile),
                              Row(
                                children: [
                                  Text('Action: ', style: kHeaderStyle()),
                                  IconButton(onPressed: (){}, icon: Icon(Icons.menu),),
                                  IconButton(onPressed: (){}, icon: Icon(Icons.edit),),
                                  IconButton(onPressed: (){}, icon: Icon(Icons.currency_rupee),),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
