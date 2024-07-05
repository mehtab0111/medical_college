import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Screens/Academics/assignSemesterTeacher.dart';
import 'package:medical_college/Screens/Academics/coursePage.dart';
import 'package:medical_college/Screens/Academics/craeteSemesterTimeTable.dart';
import 'package:medical_college/Screens/Academics/promoteStudent.dart';
import 'package:medical_college/Screens/Academics/semesterPage.dart';
import 'package:medical_college/Screens/Academics/semesterTimeTable.dart';
import 'package:medical_college/Screens/Academics/subjectGroup.dart';
import 'package:medical_college/Screens/Academics/subjectPage.dart';
import 'package:medical_college/Screens/Academics/teacherTimetable.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/provider/menuManagement_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Academics extends StatefulWidget {
  const Academics({super.key});

  @override
  State<Academics> createState() => _AcademicsState();
}

class _AcademicsState extends State<Academics> {

  @override
  Widget build(BuildContext context) {

    final menuManagementProvider = Provider.of<MenuManagementProvider>(context);
    bool createSemesterTimeTable = false;
    bool subjectGroup = false;
    bool assignSemesterTeacher = false;
    bool semesterTimeTable = false;
    bool course = false;
    bool semester = false;
    bool subject = false;
    bool promoteStudents = false;
    for(var permission in menuManagementProvider.menuManagementList){
      // print(permission.permission);
      if(permission.name == 'Create Semester Timetable'){
        createSemesterTimeTable = permission.permission;
      }
      if(permission.name == 'Subject Group'){
        subjectGroup = permission.permission;
      }
      if(permission.name == 'Assign Semester Teacher'){
        assignSemesterTeacher = permission.permission;
      }
      if(permission.name == 'Semester Timetable'){
        semesterTimeTable = permission.permission;
      }
      if(permission.name == 'Course'){
        course = permission.permission;
      }
      if(permission.name == 'Semester'){
        semester = permission.permission;
      }
      if(permission.name == 'Subject'){
        subject = permission.permission;
      }
      if(permission.name == 'Promote Students'){
        promoteStudents = permission.permission;
      }
    }

    return Container(
      decoration: kBackgroundDesign(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Academics'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if(createSemesterTimeTable != false)
              tileButton(
                context,
                leadingIcon: Icons.double_arrow_outlined,
                title: 'Create Semester Timetable',
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => CreateSemesterTable()));
                },
              ),
              if(semesterTimeTable != false)
              tileButton(
                context,
                leadingIcon: Icons.double_arrow_outlined,
                title: 'Semester Timetable',
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SemesterTimeTable()));
                },
              ),
              // tileButton(
              //   context,
              //   leadingIcon: Icons.double_arrow_outlined,
              //   title: 'Teachers Timetable',
              //   onClick: (){
              //     Navigator.push(context, MaterialPageRoute(
              //         builder: (context) => TeacherTimetable()));
              //   },
              // ),
              if(assignSemesterTeacher != false)
              tileButton(
                context,
                leadingIcon: Icons.double_arrow_outlined,
                title: 'Assign Semester Teacher',
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AssignSemesterTeacher()));
                },
              ),
              if(promoteStudents != false)
              tileButton(
                context,
                leadingIcon: Icons.double_arrow_outlined,
                title: 'Promote Student',
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => PromoteStudent()));
                },
              ),
              if(subjectGroup != false)
              tileButton(
                context,
                leadingIcon: Icons.double_arrow_outlined,
                title: 'Subject Group',
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SubjectGroup()));
                },
              ),
              if(subject != false)
              tileButton(
                context,
                leadingIcon: Icons.double_arrow_outlined,
                title: 'Subject',
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SubjectPage()));
                },
              ),
              if(course != false)
              tileButton(
                context,
                leadingIcon: Icons.double_arrow_outlined,
                title: 'Course',
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => CoursePage()));
                },
              ),
              if(semester != false)
              tileButton(
                context,
                leadingIcon: Icons.double_arrow_outlined,
                title: 'Semesters',
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SemesterPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
