import 'dart:async';
import 'dart:convert';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Screens/emptyScreen.dart';
import 'package:http/http.dart' as http;
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';

class AdmissionReport extends StatefulWidget {
  const AdmissionReport({super.key});

  @override
  State<AdmissionReport> createState() => _AdmissionReportState();
}

class _AdmissionReportState extends State<AdmissionReport> {

  final StreamController _streamController = StreamController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();

  bool isSearched = false;

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context, int type) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      if(type == 1){
        setState(() {
          selectedDate = picked;
          fromDate.text = '${picked.year}-${picked.month}-${picked.day}';
        });
      } else {
        setState(() {
          selectedDate = picked;
          toDate.text = '${picked.year}-${picked.month}-${picked.day}';
        });
      }
    }
  }

  void getStudentReport() async {
    String url = APIData.getStudentReport;
    var response = await http.post(Uri.parse(url), headers: APIData.kHeader,
      body: jsonEncode({
        "from_date": fromDate.text,
        "to_date": toDate.text,
      })
    );
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Admission Report'),
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
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('From Date', style: kSmallText()),
                    ),
                    KTextField(
                      readOnly: true,
                      title: 'From Date',
                      controller: fromDate,
                      onClick: (){
                        _selectDate(context, 1);
                      },
                      suffixButton: IconButton(
                        onPressed: (){
                          _selectDate(context, 1);
                        },
                        icon: Icon(Icons.calendar_month_outlined),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('To Date', style: kSmallText()),
                    ),
                    KTextField(
                      readOnly: true,
                      title: 'To Date',
                      controller: toDate,
                      onClick: (){
                        _selectDate(context, 2);
                      },
                      suffixButton: IconButton(
                        onPressed: (){
                          _selectDate(context, 2);
                        },
                        icon: Icon(Icons.calendar_month_outlined),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Center(
                      child: KButton(
                        title: 'Save',
                        onClick: (){
                          if(_formKey.currentState!.validate()){
                            setState(() {
                              isSearched = true;
                              getStudentReport();
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            kSpace(),
            if(isSearched == true)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: containerDesign(context),
              child: Column(
                children: [
                  Text('Student Admission Report', style: kLargeStyle(),),
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
                            String middleName = data[index]['middle_name'] != null ? '${data[index]['middle_name']} ' : '';
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: roundedShadedDesign(context),
                              child: Column(
                                children: [
                                  kRowText('ID: ', '${data[index]['id']}'),
                                  kRowText('Name: ', '${data[index]['first_name']} $middleName${data[index]['last_name']}'),
                                  kRowText('Gender: ', '${data[index]['gender']}'),
                                  kRowText('Date Of Birth: ', '${data[index]['dob']}'),
                                  kRowText('User Type: ', '${data[index]['user_type']}'),
                                  kRowText('Email	: ', '${data[index]['email']}'),
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
            )
          ],
        ),
      ),
    );
  }
}
