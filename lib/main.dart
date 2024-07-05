import 'package:medical_college/Theme/colors.dart';
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
import 'package:medical_college/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => SemesterProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProvider(create: (_) => TeacherProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => SubjectProvider()),
        ChangeNotifierProvider(create: (_) => UserTypeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MembersProvider()),
        ChangeNotifierProvider(create: (_) => PermissionProvider()),
        ChangeNotifierProvider(create: (_) => LeaveTypeProvider()),
        ChangeNotifierProvider(create: (_) => MenuManagementProvider()),
        ChangeNotifierProvider(create: (_) => WeekProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Constants.appName,
        theme: Constants.lightTheme,
        darkTheme: Constants.darkTheme,
        home: SplashScreen(),
      ),
    );
  }
}
