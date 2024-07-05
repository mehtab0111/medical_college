import 'dart:async';
import 'dart:convert';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/localDatabase.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Screens/HumanResource/generatePayroll.dart';
import 'package:medical_college/Screens/emptyScreen.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/provider/user_type_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Payroll extends StatefulWidget {
  const Payroll({super.key});

  @override
  State<Payroll> createState() => _PayrollState();
}

class _PayrollState extends State<Payroll> {

  final StreamController _streamController = StreamController();

  String roleValue = '';
  String monthValue = '';
  String yearValue = '';
  bool isSearched = false;

  @override
  void initState() {
    super.initState();
  }

  void getMembers() async {
    String url = APIData.getAllMembers;
    var response = await http.get(Uri.parse('$url/2/01/2023'),
      headers: APIData.kHeader,
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
    final userProvider = Provider.of<UserTypeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Payroll'),
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
                    padding: const EdgeInsets.only(left: 10),
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
                            value: roleValue != '' ? roleValue : null,
                            hint: Text('Role'),
                            items: userProvider.userTypeList
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value.id.toString(),
                                child: Text(value.name),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                roleValue = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text('Month', style: kSmallText()),
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
                            value: monthValue != '' ? monthValue : null,
                            hint: Text('Month'),
                            items: monthList
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value.id,
                                child: Text(value.name),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                monthValue = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text('Year', style: kSmallText()),
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
                            value: yearValue != '' ? yearValue : null,
                            hint: Text('Year'),
                            items: yearList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                yearValue = newValue!;
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
                        if(roleValue == ''){
                          toastMessage(message: 'Select Role', colors: kRedColor);
                        } else if(monthValue == ''){
                          toastMessage(message: 'Select Month', colors: kRedColor);
                        } else if(yearValue == ''){
                          toastMessage(message: 'Select Year', colors: kRedColor);
                        } else {
                          getMembers();
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
            SizedBox(height: 10.0),
            if(isSearched != false)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              decoration: containerDesign(context),
              child: Column(
                children: [
                  Text('Staff List', style: kHeaderStyle()),
                  StreamBuilder(
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        var data = snapshot.data;
                        return data.isNotEmpty ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index){
                            String middleName = data[index]['middle_name'] != null ? '${data[index]['first_name']} ' : '';
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.0),
                              child: Container(
                                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                                decoration: roundedShadedDesign(context),
                                child: Column(
                                  children: [
                                    kRowText('Staff ID: ', data[index]['id'].toString()),
                                    kRowText('Name: ', '${data[index]['first_name']} $middleName${data[index]['last_name']}'),
                                    kRowText('Gender: ', data[index]['gender']),
                                    kRowText('Date Of Birth: ', '${data[index]['dob']}'),
                                    kRowText('Email: ', data[index]['email']),
                                    TextButton(
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => GeneratePayroll()));
                                      },
                                      child: Text('Generate Payroll'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ) : Padding(
                          padding: const EdgeInsets.all(20),
                          child: EmptyScreen(message: 'No data Found'),
                        );
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
