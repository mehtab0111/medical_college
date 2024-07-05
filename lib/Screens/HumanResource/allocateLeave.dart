import 'dart:async';
import 'dart:convert';
import 'package:medical_college/Components/DialougBox/deletePopUp.dart';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Screens/emptyScreen.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/provider/leaveType_provider.dart';
import 'package:medical_college/provider/members_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AllocateLeave extends StatefulWidget {
  const AllocateLeave({super.key});

  @override
  State<AllocateLeave> createState() => _AllocateLeaveState();
}

class _AllocateLeaveState extends State<AllocateLeave> {

  final StreamController _streamController = StreamController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController leaveCount = TextEditingController();

  String memberValue = '';
  String leaveTypeValue = '';
  bool updateData = false;

  @override
  void initState() {
    super.initState();
    getLeaveList();
  }

  Future<String> getLeaveList() async {
    String url = APIData.getLeaveList;
    var response = await http.get(Uri.parse(url),
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

  Future<String> saveLeaveList() async {
    String url = APIData.saveLeaveList;
    var response = await http.post(Uri.parse(url),
      headers: APIData.kHeader,
      body: jsonEncode({
        "id": null,
        "user_id": memberValue,
        "leave_type_id": leaveTypeValue,
        "total_leave": leaveCount.text,
      }),
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Leave Allocated');
      setState(() {
        memberValue = '';
        leaveTypeValue = '';
        leaveCount.clear();
      });
      getLeaveList();
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
    final memberProvider = Provider.of<MembersProvider>(context);
    final leaveTypeProvider = Provider.of<LeaveTypeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Allocate Leave'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
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
                        Text('Leave Type', style: kBoldStyle()),
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
                              value: leaveTypeValue != '' ? leaveTypeValue : null,
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
                                  leaveTypeValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    KTextField(title: 'Leave Count', controller: leaveCount,),
                    SizedBox(height: 5),
                    updateData != true ? KButton(
                      title: 'Submit',
                      onClick: (){
                        if(_formKey.currentState!.validate()){
                          saveLeaveList();
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
                                updateLeaveList(context);
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
                                  // semesterName.clear();
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
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: containerDesign(context),
              child: Column(
                children: [
                  Text('Leave Allocation List', style: kHeaderStyle()),
                  StreamBuilder(
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        var data = snapshot.data;
                        return data.isNotEmpty ? ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index){
                            return Container(
                              padding: EdgeInsets.only(left: 10.0, top: 5, bottom: 5),
                              decoration: roundedShadedDesign(context),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        kRowText('User Name: ', '${data[index]['user_name']}'),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: data[index]['leave_type'].length,
                                          itemBuilder: (context, ind){
                                            var leaveType = data[index]['leave_type'];
                                            return kRowText('Leaves: ', '${leaveType[ind]['name']} - ${leaveType[ind]['total_leave']}');
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: (){
                                      print(data[index]);
                                      setState(() {
                                        updateData = true;
                                        memberValue = '${data[index]['user_id']}';
                                        leaveTypeValue = '${data[index]['leave_type'][0]['id']}';
                                        leaveCount.text = '${data[index]['leave_type'][0]['total_leave']}';
                                      });
                                    },
                                    icon: Icon(Icons.edit_outlined),
                                  ),
                                  IconButton(
                                    onPressed: (){
                                      deletePopUp(
                                        context,
                                        onClickYes: (){
                                          deleteLeaveList(id: '${data[index]['user_id']}');
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return kSpace();
                          },
                        ) : Container(
                          padding: EdgeInsets.all(10),
                          decoration: roundedShadedDesign(context),
                          child: EmptyScreen(message: 'No Leave Allocate Found'),
                        );
                      }
                      return LoadingIcon();
                    }
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> updateLeaveList(context) async {
    String url = APIData.updateLeaveList;
    var response = await http.post(Uri.parse(url), headers: APIData.kHeader,
      body: jsonEncode({
        "id": null,
        "user_id": memberValue,
        "leave_type_id": leaveTypeValue,
        "total_leave": leaveCount.text,
      }),
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Leave Allocated');
      setState(() {
        updateData = false;
        memberValue = '';
        leaveTypeValue = '';
        leaveCount.clear();
      });
      getLeaveList();
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  Future<String> deleteLeaveList({required String id}) async {
    String url = APIData.deleteLeaveList;
    var response = await http.get(Uri.parse('$url/$id'), headers: APIData.kHeader);
    if(response.statusCode == 200){
      toastMessage(message: 'Leave Allocated Deleted');
      getLeaveList();
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }
}
