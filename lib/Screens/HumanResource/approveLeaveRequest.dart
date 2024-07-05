import 'dart:async';
import 'dart:convert';
import 'package:medical_college/Components/DialougBox/popup.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Screens/emptyScreen.dart';
import 'package:http/http.dart' as http;
import 'package:medical_college/Screens/HumanResource/addLeaveRequest.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';

class ApproveLeaveRequest extends StatefulWidget {
  const ApproveLeaveRequest({super.key});

  @override
  State<ApproveLeaveRequest> createState() => _ApproveLeaveRequestState();
}

class _ApproveLeaveRequestState extends State<ApproveLeaveRequest> with SingleTickerProviderStateMixin{

  final StreamController _streamController = StreamController();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    getLeaveList();
  }

  Future<String> getLeaveList() async {
    String url = APIData.getLeave;
    var response = await http.get(Uri.parse(url),
      headers: APIData.kHeader,
    );
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      if(!_streamController.isClosed){
        _streamController.add(jsonData['data']);
      }
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Approve Leave Request'),
        actions: [
          // TextButton(
          //   onPressed: (){
          //     Navigator.push(context, MaterialPageRoute(builder: (context) => AddLeaveRequest()));
          //   },
          //   child: Text('+Add'),
          // ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'Pending'),
            Tab(text: 'Approve'),
            Tab(text: 'Decline'),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            var leaveList = snapshot.data;
            List approveLeave = [];
            List declineLeave = [];
            List pendingLeave = [];
            for(var item in leaveList){
              if(item['approved'] == 1){
                approveLeave.add(item);
              } else if(item['approved'] == 2){
                declineLeave.add(item);
              } else {
                pendingLeave.add(item);
              }
            }
            return TabBarView(
              controller: _tabController,
              children: [
                leaveListData(pendingLeave),
                leaveListData(approveLeave),
                leaveListData(declineLeave),
              ],
            );
          }
          return LoadingIcon();
        }
      ),
    );
  }

  Widget leaveListData(data) {
    return data.isNotEmpty ? ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      physics: BouncingScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: roundedShadedDesign(context),
            child: Column(
              children: [
                kRowText('User ID: ', '${data[index]['user_id']}'),
                kRowText('User Name: ', '${data[index]['user_name']}'),
                kRowText('Leave Type: ', '${data[index]['leave_type_name']}'),
                kRowText('From Date: ', '${data[index]['from_date']}'),
                kRowText('To Date: ', '${data[index]['to_date']}'),
                kRowText('Total Days: ', '${data[index]['total_days']}'),
                kRowText('Reason: ', '${data[index]['reason']}'),
                kRowText('Status: ', data[index]['approved'] == 0 ?
                'Pending' : data[index]['approved'] == 1 ? 'Approve' : 'Rejected'),
                Row(
                  children: [
                    Text('Action: ', style: kBoldStyle()),
                    IconButton(
                      onPressed: (){
                        kPopUp(context,
                          title: 'Accept?',
                          desc: 'Accept this leave request.',
                          onClickYes: (){
                            updateApproval(
                              leaveID: '${data[index]['id']}',
                              status: '1',
                            );
                            Navigator.pop(context);
                          },
                        );
                        getLeaveList();
                      },
                      icon: Icon(Icons.check_outlined),
                    ),
                    IconButton(
                      onPressed: (){
                        kPopUp(context,
                          title: 'Reject?',
                          desc: 'Reject this leave request.',
                          onClickYes: (){
                            updateApproval(
                              leaveID: '${data[index]['id']}',
                              status: '2',
                            );
                            Navigator.pop(context);
                          },
                        );
                        getLeaveList();
                      },
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ) : EmptyScreen(message: 'No Request Found');
  }

  Future<String> updateApproval({required String leaveID,
    required String status}) async {
    String url = APIData.updateApproval;
    var response = await http.get(Uri.parse('$url/$leaveID/$status'),
        headers: APIData.kHeader);
    if(response.statusCode == 200){
      toastMessage(message: 'Leave Updated');
      getLeaveList();
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }
}
