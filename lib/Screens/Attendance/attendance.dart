import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Screens/Attendance/periodAttendance.dart';
import 'package:medical_college/Screens/Attendance/showAttendance.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/provider/menuManagement_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {

  @override
  Widget build(BuildContext context) {

    final menuManagementProvider = Provider.of<MenuManagementProvider>(context);
    bool periodAttendancePermission = false;
    bool showAttendance = false;
    for(var permission in menuManagementProvider.menuManagementList){
      if(permission.name == 'Period Attendance'){
        periodAttendancePermission = permission.permission;
      }
      if(permission.name == 'Show Attendance'){
        showAttendance = permission.permission;
      }
    }
    return Container(
      decoration: kBackgroundDesign(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Attendance'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if(periodAttendancePermission != false)
              tileButton(
                context,
                leadingIcon: Icons.double_arrow_outlined,
                title: 'Period Attendance',
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => PeriodAttendance()));
                },
              ),
              if(showAttendance != false)
              tileButton(
                context,
                leadingIcon: Icons.double_arrow_outlined,
                title: 'Show Attendance',
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ShowAttendance()));
                },
              ),
              // tileButton(
              //   context,
              //   leadingIcon: Icons.double_arrow_outlined,
              //   title: 'Period Attendance By Date',
              //   onClick: (){
              //     Navigator.push(context, MaterialPageRoute(
              //         builder: (context) => PeriodAttendanceByDate()));
              //   },
              // ),
              // tileButton(
              //   context,
              //   leadingIcon: Icons.double_arrow_outlined,
              //   title: 'Approve Leave',
              //   onClick: (){
              //     Navigator.push(context, MaterialPageRoute(
              //         builder: (context) => ApproveLeave()));
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
