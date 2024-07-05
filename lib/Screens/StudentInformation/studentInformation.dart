import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Screens/StudentInformation/showStudent.dart';
import 'package:medical_college/Screens/StudentInformation/studentAdmission.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/provider/menuManagement_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentInformation extends StatefulWidget {
  const StudentInformation({super.key});

  @override
  State<StudentInformation> createState() => _StudentInformationState();
}

class _StudentInformationState extends State<StudentInformation> {

  @override
  Widget build(BuildContext context) {
    final menuManagementProvider = Provider.of<MenuManagementProvider>(context);
    bool studentAdmission = false;
    for(var permission in menuManagementProvider.menuManagementList){
      // print(permission.permission);
      if(permission.name == 'Student Admission'){
        studentAdmission = permission.permission;
      }
    }
    return Container(
      decoration: kBackgroundDesign(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Student Information'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // tileButton(
              //   context,
              //   leadingIcon: Icons.double_arrow,
              //   title: 'Student Details',
              //   onClick: (){
              //     Navigator.push(context, MaterialPageRoute(builder: (context) => StudentDetails()));
              //   },
              // ),
              // if(studentAdmission != false)
              tileButton(
                context,
                leadingIcon: Icons.double_arrow,
                title: 'Student Admission',
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StudentAdmission()));
                },
              ),
              // if(studentAdmission != false)
              tileButton(
                context,
                leadingIcon: Icons.double_arrow,
                title: 'Show Student',
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ShowStudent()));
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
