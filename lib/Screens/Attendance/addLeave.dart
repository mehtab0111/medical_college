import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/localDatabase.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';

class AddLeave extends StatefulWidget {
  const AddLeave({super.key});

  @override
  State<AddLeave> createState() => _AddLeaveState();
}

class _AddLeaveState extends State<AddLeave> {

  TextEditingController appleDate = TextEditingController();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();

  String courseValue = '';
  String semesterValue = '';
  String studentValue = '';

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context, int dateType) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      if(dateType == 1) {
        setState(() {
          appleDate.text = '${picked.day}-${picked.month}-${picked.year}';
        });
      }
      if(dateType == 2) {
        setState(() {
          fromDate.text = '${picked.day}-${picked.month}-${picked.year}';
        });
      }
      if(dateType == 3) {
        setState(() {
          toDate.text = '${picked.day}-${picked.month}-${picked.year}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Leave'),
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
                  Row(
                    children: [
                      SizedBox(width: 10.0),
                      Text('Student', style: kSmallText()),
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
                            value: studentValue != '' ? studentValue : null,
                            hint: Text('Student'),
                            items: ['Tithi Biswas', 'Ayan Kuila', 'Suvendhu Patra']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
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
                  KTextField(
                    readOnly: true,
                    title: 'Apply date',
                    controller: appleDate,
                    suffixButton: IconButton(
                      onPressed: (){
                        _selectDate(context, 1);
                      },
                      icon: Icon(Icons.calendar_month_outlined),
                    ),
                  ),
                  KTextField(
                    readOnly: true,
                    title: 'From date',
                    controller: fromDate,
                    suffixButton: IconButton(
                      onPressed: (){
                        _selectDate(context, 2);
                      },
                      icon: Icon(Icons.calendar_month_outlined),
                    ),
                  ),
                  KTextField(
                    readOnly: true,
                    title: 'To date',
                    controller: toDate,
                    suffixButton: IconButton(
                      onPressed: (){
                        _selectDate(context, 3);
                      },
                      icon: Icon(Icons.calendar_month_outlined),
                    ),
                  ),
                  MessageTextField(title: 'Reason'),
                  SizedBox(height: 5.0),
                  KButton(
                    title: 'Save',
                    onClick: (){
                      Navigator.pop(context);
                    },
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
