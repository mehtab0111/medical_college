import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Screens/HumanResource/allocateLeave.dart';
import 'package:medical_college/Screens/HumanResource/applyLeaves.dart';
import 'package:medical_college/Screens/HumanResource/approveLeaveRequest.dart';
import 'package:medical_college/Screens/HumanResource/department.dart';
import 'package:medical_college/Screens/HumanResource/designation.dart';
import 'package:medical_college/Screens/HumanResource/leaveType.dart';
import 'package:medical_college/Screens/HumanResource/payroll.dart';
import 'package:medical_college/Screens/HumanResource/staffAttendance.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/provider/menuManagement_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HumanResource extends StatefulWidget {
  const HumanResource({super.key});

  @override
  State<HumanResource> createState() => _HumanResourceState();
}

class _HumanResourceState extends State<HumanResource> {

  @override
  Widget build(BuildContext context) {

    final menuManagementProvider = Provider.of<MenuManagementProvider>(context);
    bool staffAttendance = false;
    bool payroll = false;
    bool approveLeave = false;
    bool applyLeave = false;
    bool leaveType = false;
    bool department = false;
    bool designation = false;
    for(var permission in menuManagementProvider.menuManagementList){
      if(permission.name == 'Staff Attendance'){
        staffAttendance = permission.permission;
      }
      if(permission.name == 'Payroll'){
        payroll = permission.permission;
      }
      if(permission.name == 'Approve Leave'){
        approveLeave = permission.permission;
      }
      if(permission.name == 'Apply Leave'){
        applyLeave = permission.permission;
      }
      if(permission.name == 'Leave Type'){
        leaveType = permission.permission;
      }
      if(permission.name == 'Department'){
        department = permission.permission;
      }
      if(permission.name == 'Designation'){
        designation = permission.permission;
      }
    }

    return Container(
      decoration: kBackgroundDesign(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Human Resource'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // tileButton(
              //   context,
              //   leadingIcon: Icons.double_arrow,
              //   title: 'Staff Directory',
              //   onClick: (){
              //     Navigator.push(context, MaterialPageRoute(builder: (context) => StaffDirectory()));
              //   },
              // ),
              if(staffAttendance != false)
              tileButton(
                context,
                leadingIcon: Icons.double_arrow,
                title: 'Staff Attendance',
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StaffAttendance()));
                },
              ),
              if(leaveType != false)
                tileButton(
                  context,
                  leadingIcon: Icons.double_arrow,
                  title: 'Leave Type',
                  onClick: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveType()));
                  },
                ),
              // if(leaveType != false)
                tileButton(
                  context,
                  leadingIcon: Icons.double_arrow,
                  title: 'Allocate Leave',
                  onClick: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AllocateLeave()));
                  },
                ),
              if(applyLeave != false)
                tileButton(
                  context,
                  leadingIcon: Icons.double_arrow,
                  title: 'Apply Leave',
                  onClick: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyLeaves()));
                  },
                ),
              if(approveLeave != false)
              tileButton(
                context,
                leadingIcon: Icons.double_arrow,
                title: 'Approve Leave Request',
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ApproveLeaveRequest()));
                },
              ),
              if(department != false)
              tileButton(
                context,
                leadingIcon: Icons.double_arrow,
                title: 'Department',
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Department()));
                },
              ),
              if(designation != false)
              tileButton(
                context,
                leadingIcon: Icons.double_arrow,
                title: 'Designation',
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Designation()));
                },
              ),
              if(payroll != false)
                tileButton(
                  context,
                  leadingIcon: Icons.double_arrow,
                  title: 'Payroll',
                  onClick: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Payroll()));
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
