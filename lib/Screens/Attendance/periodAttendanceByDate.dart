import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/localDatabase.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';

class PeriodAttendanceByDate extends StatefulWidget {
  const PeriodAttendanceByDate({super.key});

  @override
  State<PeriodAttendanceByDate> createState() => _PeriodAttendanceByDateState();
}

class _PeriodAttendanceByDateState extends State<PeriodAttendanceByDate> {

  TextEditingController date = TextEditingController();

  String courseValue = '';
  String semesterValue = '';
  bool markAsHoliday = false;

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        date.text = '${picked.day}-${picked.month}-${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Period Attendance By Date'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: containerDesign(context),
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
                  KTextField(
                    readOnly: true,
                    title: 'Date',
                    controller: date,
                    suffixButton: IconButton(
                      onPressed: (){
                        _selectDate(context);
                      },
                      icon: Icon(Icons.calendar_month_outlined),
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
                  Text('Student List', style: kHeaderStyle()),
                  SizedBox(height: 10.0),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: studentList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: roundedContainerDesign(context).copyWith(
                          boxShadow: boxShadowDesign(),
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            kRowText('Student: ', studentList[index].studentName),
                            Column(
                              children: [
                                Text("Clinical Immunology (Theory) (PAPER VIII, UNIT 15)"
                                    "10:15 AM - 11:00 AM", style: kBoldStyle()),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: k3Color,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Text('N/A', style: kWhiteTextStyle()),
                                ),
                                Text("Haematology (Practical) (PAPER VII, UNIT 14)"
                                    "11:00 AM - 1:00 PM", style: kBoldStyle()),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: k3Color,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Text('N/A', style: kWhiteTextStyle()),
                                ),
                                Text("Serology (Theory) (PAPER IX, UNIT 17)"
                                    "2:00 PM - 3:00 PM", style: kBoldStyle()),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: k3Color,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Text('N/A', style: kWhiteTextStyle()),
                                ),
                                Text("Haematology (Theory) (PAPER VII, UNIT 13)"
                                    "3:00 PM - 4:00 PM", style: kBoldStyle()),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: k3Color,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Text('N/A', style: kWhiteTextStyle()),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index){
                      return SizedBox(height: 10.0);
                    },
                  ),
                  SizedBox(height: 5.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
