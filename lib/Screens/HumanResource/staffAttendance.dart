import 'dart:async';
import 'dart:convert';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Screens/emptyScreen.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:http/http.dart' as http;
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/provider/user_type_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StaffAttendance extends StatefulWidget {
  const StaffAttendance({super.key});

  @override
  State<StaffAttendance> createState() => _StaffAttendanceState();
}

class _StaffAttendanceState extends State<StaffAttendance> {

  final StreamController _streamController = StreamController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController attendanceDate = TextEditingController();

  String userValue = '';
  // bool markedAsHoliday = false;

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        attendanceDate.text = '${picked.day}-${picked.month}-${picked.year}';
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<String> getStaffAttendance() async {
    String url = APIData.getStaffAttendance;
    var response = await http.get(Uri.parse('$url/$userValue/${attendanceDate.text}'),
      headers: APIData.kHeader,
    );
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      _streamController.add(jsonData['data']);
    } else {
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
    final userProvider = Provider.of<UserTypeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Staff Attendance'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: containerDesign(context),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text('Role', style: kSmallText()),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: dropTextFieldDesign(),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(10.0),
                              value: userValue != '' ? userValue : null,
                              hint: Text('Role'),
                              items: userProvider.userTypeList
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.name),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                print(newValue);
                                setState(() {
                                  userValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text('Attendance Date', style: kSmallText()),
                    ),
                    KTextField(
                      readOnly: true,
                      title: 'Attendance date',
                      controller: attendanceDate,
                      onClick: (){
                        _selectDate(context);
                      },
                      suffixButton: IconButton(
                        onPressed: (){
                          _selectDate(context);
                        },
                        icon: Icon(Icons.calendar_month_outlined),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Center(
                      child: KButton(
                        title: 'Search',
                        onClick: (){
                          if(_formKey.currentState!.validate()){
                            if(userValue == ''){
                              toastMessage(message: 'Select Role', colors: kRedColor);
                            } else {
                              getStaffAttendance();
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: containerDesign(context),
              child: Column(
                children: [
                  Text('Staff List', style: kHeaderStyle()),
                  SizedBox(height: 5.0),
                  StreamBuilder(
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        var data = snapshot.data;
                        return ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index){
                            String middleName = data[index]['middle_name'] != null ?
                            '${data[index]['middle_name']} ' : '';
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              decoration: roundedContainerDesign(context).copyWith(
                                boxShadow: boxShadowDesign(),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        kRowText('Staff ID: ', data[index]['id'].toString()),
                                        kRowText('Name: ', '${data[index]['first_name']} $middleName${data[index]['last_name']}'),
                                        // kRowText('Role: ', staffList[index].role),
                                        Text('Attendance ', style: kBoldStyle()),
                                        Row(
                                          children: [
                                            radioButton(
                                              iconData: data[index]['attendance'] == 'present' ?
                                              Icons.radio_button_checked : Icons.radio_button_off,
                                              title: 'Present',
                                              onClick: (){
                                                setState(() {
                                                  data[index]['attendance'] = 'present';
                                                });
                                              },
                                            ),
                                            radioButton(
                                              iconData: data[index]['attendance'] == 'late' ?
                                              Icons.radio_button_checked : Icons.radio_button_off,
                                              title: 'Late',
                                              onClick: (){
                                                setState(() {
                                                  data[index]['attendance'] = 'late';
                                                });
                                              },
                                            ),
                                            radioButton(
                                              iconData: data[index]['attendance'] == 'absent' ?
                                              Icons.radio_button_checked : Icons.radio_button_off,
                                              title: 'Absent',
                                              onClick: (){
                                                setState(() {
                                                  data[index]['attendance'] = 'absent';
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            radioButton(
                                              iconData: data[index]['attendance'] == 'halfDay' ?
                                              Icons.radio_button_checked : Icons.radio_button_off,
                                              title: 'Half Day',
                                              onClick: (){
                                                setState(() {
                                                  data[index]['attendance'] = 'halfDay';
                                                });
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return kSpace();
                          },
                        );
                      }
                      return EmptyScreen(message: 'No Attendance Found');
                    }
                  ),
                  SizedBox(height: 10.0),
                  KButton(
                    title: 'Save Attendance',
                    onClick: (){
                      saveAttendance();
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

  Future<String> saveAttendance() async {
    String url = APIData.saveAttendance;
    var response = await http.post(Uri.parse(url),
      headers: APIData.kHeader, body: jsonEncode({
        "course_id": 2 ,
        "semester_id": 2,
        "subject_id": 1,
        "date": attendanceDate.text,
        "user_id": 3,
        "attendance": "present"
      }),
    );
    if(response.statusCode == 200){
      getStaffAttendance();
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }
}
