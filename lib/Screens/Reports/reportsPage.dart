import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Screens/Reports/admissionReport.dart';
import 'package:medical_college/Screens/Reports/feesDueReport.dart';
import 'package:medical_college/Screens/Reports/attendnceReport.dart';
import 'package:medical_college/Screens/Reports/feesCollectionReport.dart';
import 'package:medical_college/provider/menuManagement_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {

  @override
  Widget build(BuildContext context) {

    final menuManagementProvider = Provider.of<MenuManagementProvider>(context);
    bool admissionReport = false;
    bool attendanceReport = false;
    bool feesCollectionReport = false;
    for(var permission in menuManagementProvider.menuManagementList){
      if(permission.name == 'Admission report'){
        admissionReport = permission.permission;
      }
      if(permission.name == 'Attendance report'){
        attendanceReport = permission.permission;
      }
      if(permission.name == 'Fees Collection report'){
        feesCollectionReport = permission.permission;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if(admissionReport != false)
            tileButton(
              context,
              leadingIcon: Icons.double_arrow,
              title: 'Admission Report',
              onClick: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdmissionReport()));
              },
            ),
            if(attendanceReport != false)
            tileButton(
              context,
              leadingIcon: Icons.double_arrow,
              title: 'Attendance Report',
              onClick: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AttendanceReport()));
              },
            ),
            // tileButton(
            //   context,
            //   leadingIcon: Icons.double_arrow,
            //   title: 'Staff Attendance Report',
            //   onClick: (){
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => StaffAttendanceReport()));
            //   },
            // ),
            if(feesCollectionReport != false)
            tileButton(
              context,
              leadingIcon: Icons.double_arrow,
              title: 'Fees Collection Report',
              onClick: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => FeesCollectionReport()));
              },
            ),
            tileButton(
              context,
              leadingIcon: Icons.double_arrow,
              title: 'Fees Due Report',
              onClick: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => FeesDueReport()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
