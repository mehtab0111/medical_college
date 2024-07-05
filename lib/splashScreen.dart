import 'dart:async';
import 'package:medical_college/Screens/Auth/loginPage.dart';
import 'package:medical_college/Screens/navigationScreen.dart';
import 'package:medical_college/Services/serviceManager.dart';
import 'package:medical_college/provider/course_provider.dart';
import 'package:medical_college/provider/leaveType_provider.dart';
import 'package:medical_college/provider/members_provider.dart';
import 'package:medical_college/provider/menuManagement_provider.dart';
import 'package:medical_college/provider/permission_provider.dart';
import 'package:medical_college/provider/semester_provider.dart';
import 'package:medical_college/provider/session_provider.dart';
import 'package:medical_college/provider/student_provider.dart';
import 'package:medical_college/provider/subject_provider.dart';
import 'package:medical_college/provider/teacher_provider.dart';
import 'package:medical_college/provider/user_provider.dart';
import 'package:medical_college/provider/user_type_provider.dart';
import 'package:medical_college/provider/week_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    ServiceManager().getUserID();
    ServiceManager().getTokenID();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {

      if(ServiceManager.userID != ''){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) => NavigationScreen()), (route) => false);
        getData();
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) => LoginPage()), (route) => false);
      }

      if(_timer.isActive) _timer.cancel();
    });
  }

  void getData() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      CourseProvider courseProvider = Provider.of<CourseProvider>(context, listen: false);
      SemesterProvider semesterProvider = Provider.of<SemesterProvider>(context, listen: false);
      SessionProvider sessionProvider = Provider.of<SessionProvider>(context, listen: false);
      TeacherProvider teacherProvider = Provider.of<TeacherProvider>(context, listen: false);
      StudentProvider studentProvider = Provider.of<StudentProvider>(context, listen: false);
      SubjectProvider subjectProvider = Provider.of<SubjectProvider>(context, listen: false);
      UserTypeProvider userTypeProvider = Provider.of<UserTypeProvider>(context, listen: false);
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      MembersProvider membersProvider = Provider.of<MembersProvider>(context, listen: false);
      PermissionProvider permissionProvider = Provider.of<PermissionProvider>(context, listen: false);
      LeaveTypeProvider leaveTypeProvider = Provider.of<LeaveTypeProvider>(context, listen: false);
      MenuManagementProvider menuManagementProvider = Provider.of<MenuManagementProvider>(context, listen: false);
      WeekProvider weekProvider = Provider.of<WeekProvider>(context, listen: false);
      await menuManagementProvider.fetchData();
      await courseProvider.fetchData();
      await semesterProvider.fetchData();
      await sessionProvider.fetchData();
      await teacherProvider.fetchData();
      await studentProvider.fetchData();
      await subjectProvider.fetchData();
      await userTypeProvider.fetchData();
      await userProvider.fetchData();
      await membersProvider.fetchData();
      await permissionProvider.fetchData();
      await leaveTypeProvider.fetchData();
      await weekProvider.fetchData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    if(_timer.isActive) _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(
            child: CircleAvatar(
              radius: 90,
              backgroundImage: AssetImage('images/app_logo.png'),
            ),
          ),
        ],
      ),
    );
  }
}
