import 'dart:async';
import 'dart:convert';
import 'package:medical_college/Components/DialougBox/deletePopUp.dart';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/provider/leaveType_provider.dart';
import 'package:medical_college/provider/members_provider.dart';
import 'package:http/http.dart' as http;
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApplyLeaves extends StatefulWidget {
  const ApplyLeaves({super.key});

  @override
  State<ApplyLeaves> createState() => _ApplyLeavesState();
}

class _ApplyLeavesState extends State<ApplyLeaves> {

  final ScrollController _scrollController = ScrollController();
  final StreamController _streamController = StreamController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController totalDays = TextEditingController();
  TextEditingController remainingDays = TextEditingController();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController reason = TextEditingController();

  String memberValue = '';
  String leaveValue = '';
  bool updateData = false;

  DateTime selectedDate = DateTime.now();
  DateTime? fromDateTime;
  DateTime? toDateTime;
  Future<void> _selectDate(BuildContext context, int dateType) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        if (dateType == 2) {
          fromDateTime = picked;
          fromDate.text = '${picked.year}-${picked.month}-${picked.day}';
        }
        if (dateType == 3) {
          toDateTime = picked;
          toDate.text = '${picked.year}-${picked.month}-${picked.day}';
        }
        if (fromDateTime != null && toDateTime != null) {
          int differenceInDays = toDateTime!.difference(fromDateTime!).inDays + 1;
          print('Number of days: $differenceInDays');
          totalDays.text = '$differenceInDays';
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLeaveList();
  }

  Future<String> getLeaveList() async {
    String url = APIData.getLeave;
    var response = await http.get(Uri.parse(url),
      headers: APIData.kHeader,
    );
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      // print(jsonData);
      _streamController.add(jsonData['data']);
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  Future<String> getLeavesBy() async {
    String url = APIData.getLeavesBy;
    var response = await http.get(Uri.parse('$url/$memberValue/$leaveValue'),
      headers: APIData.kHeader,
    );
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      setState(() {
        remainingDays.text = jsonData['data']['total_leave'].toString();
      });
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
    final memberProvider = Provider.of<MembersProvider>(context, listen: false);
    final leaveTypeProvider = Provider.of<LeaveTypeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply Leaves'),
        // actions: [
        //   TextButton(
        //     onPressed: (){
        //       Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyLeaveForm()));
        //     },
        //     child: Text('Apply Leave'),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: containerDesign(context),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text('Select Member', style: kBoldStyle()),
                      ],
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
                              value: memberValue != '' ? memberValue : null,
                              hint: Text('Select Member'),
                              items: memberProvider.memberList
                                  .map<DropdownMenuItem<String>>((value) {
                                String middleName = value.middleName != '' ? '${value.middleName} ' : '';
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text('${value.firstName} $middleName${value.lastName}'),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  memberValue = newValue!;
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
                        Text('Leave Type', style: kSmallText()),
                      ],
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
                              value: leaveValue != '' ? leaveValue : null,
                              hint: Text('Leave Type'),
                              items: leaveTypeProvider.leaveTypeList
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.name),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  leaveValue = newValue!;
                                });
                                getLeavesBy();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    KTextField(
                      readOnly: true,
                      title: 'Total Days',
                      controller: totalDays,
                    ),
                    KTextField(
                      readOnly: true,
                      title: 'Remaining Days',
                      controller: remainingDays,
                    ),
                    KTextField(
                      readOnly: true,
                      title: 'Leave From Date',
                      controller: fromDate,
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
                    KTextField(
                      readOnly: true,
                      title: 'Leave To Date',
                      controller: toDate,
                      onClick: (){
                        _selectDate(context, 3);
                      },
                      suffixButton: IconButton(
                        onPressed: (){
                          _selectDate(context, 3);
                        },
                        icon: Icon(Icons.calendar_month_outlined),
                      ),
                    ),
                    KTextField(title: 'Reasons', controller: reason),
                    SizedBox(height: 10.0),
                    updateData != true ? KButton(
                      title: 'Save',
                      onClick: (){
                        if(_formKey.currentState!.validate()){
                          if(int.parse(totalDays.text) < int.parse(remainingDays.text)){
                            saveLeave(context);
                          } else {
                            toastMessage(message: 'Applied leave cannot be greater then remaining leave', colors: Colors.red);
                          }
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
                                if(int.parse(totalDays.text) <= int.parse(remainingDays.text)){
                                  updateLeave(context);
                                } else {
                                  toastMessage(message: 'Applied leave cannot be greater then remaining leave', colors: Colors.red);
                                }
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
                                  memberValue = '';
                                  leaveValue = '';
                                  totalDays.clear();
                                  fromDate.clear();
                                  toDate.clear();
                                  reason.clear();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            kSpace(),
            StreamBuilder(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  var data = snapshot.data;
                  return ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index){
                      return Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: roundedShadedDesign(context),
                        child: Column(
                          children: [
                            kRowText('User ID: ', '${data[index]['user_id']}'),
                            kRowText('Leave Type: ', '${data[index]['leave_type_name']}'),
                            kRowText('From Date: ', '${data[index]['from_date']}'),
                            kRowText('To Date: ', '${data[index]['to_date']}'),
                            Row(
                              children: [
                                Text('Action', style: kBoldStyle()),
                                IconButton(
                                  onPressed: (){
                                    print(data[index]);
                                    _scrollController.jumpTo(0);
                                    setState(() {
                                      updateData = true;
                                      memberValue = '${data[index]['user_id']}';
                                      leaveValue = '${data[index]['leave_type_id']}';
                                      totalDays.text = '${data[index]['total_days']}';
                                      fromDate.text = '${data[index]['from_date']}';
                                      toDate.text = '${data[index]['to_date']}';
                                      reason.text = '${data[index]['reason']}';
                                    });
                                  },
                                  icon: Icon(Icons.edit_outlined),
                                ),
                                IconButton(
                                  onPressed: (){
                                    deletePopUp(context, onClickYes: (){
                                      deleteLeave(leaveID: '${data[index]['id']}');
                                      Navigator.pop(context);
                                    });
                                  },
                                  icon: Icon(Icons.delete_forever_outlined),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return kSpace();
                    },
                  );
                }
                return LoadingIcon();
              }
            ),
          ],
        ),
      ),
    );
  }

  Future<String> saveLeave(context) async {
    String url = APIData.saveLeave;
    var response = await http.post(Uri.parse(url), headers: APIData.kHeader,
      body: jsonEncode({
        "id": null,
        "user_id": memberValue,
        "leave_type_id": leaveValue,
        "from_date": fromDate.text,
        "to_date": toDate.text,
        "reason": reason.text,
        "total_days": totalDays.text,
        "remaining_leave": remainingDays.text
      }),
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Leave applied');
      getLeaveList();
    } else {
      print(response.statusCode);
      getLeaveList();
    }
    return 'Success';
  }

  Future<String> updateLeave(context) async {
    String url = APIData.updateLeave;
    var response = await http.post(Uri.parse(url), headers: APIData.kHeader,
      body: jsonEncode({
        "id": null,
        "user_id": memberValue,
        "leave_type_id": leaveValue,
        "from_date": fromDate.text,
        "to_date": toDate.text,
        "reason": reason.text,
        "total_days": totalDays.text,
        "remaining_leave": remainingDays.text
      }),
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Leave Updated');
      setState(() {
        updateData = false;
        memberValue = '';
        leaveValue = '';
        totalDays.clear();
        fromDate.clear();
        toDate.clear();
        reason.clear();
      });
      getLeaveList();
    } else {
      print(response.statusCode);
      getLeaveList();
    }
    return 'Success';
  }

  Future<String> deleteLeave({required String leaveID}) async {
    String url = APIData.deleteLeave;
    var response = await http.get(Uri.parse('$url/$leaveID'),
        headers: APIData.kHeader);
    if(response.statusCode == 200){
      toastMessage(message: 'Leave Request Deleted');
      getLeaveList();
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }
}
