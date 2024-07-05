import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Screens/Academics/academics.dart';
import 'package:medical_college/Screens/Attendance/attendance.dart';
import 'package:medical_college/Screens/Home/homePage.dart';
import 'package:medical_college/Screens/HumanResource/humanResource.dart';
import 'package:medical_college/Screens/NavigationController.dart';
import 'package:medical_college/Services/serviceManager.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/model/user_type_model.dart';
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
import 'package:medical_college/staffFaceAttendance.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  int _selectedIndex = 0;
  bool isLoading = true;

  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Academics(),
    Attendance(),
    HumanResource(),
    NavigationController(),
    // Container(),
    // ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    ServiceManager().getUserID();
    ServiceManager().getTokenID();
    if(ServiceManager.userID != ''){
      // LocationService().fetchLocation();
      // ServiceManager().getUserData();
      // ServiceManager().getSettings();
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      getHomePageData();
    });
  }

  Future<void> getHomePageData() async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        CourseProvider courseProvider = Provider.of<CourseProvider>(
            context, listen: false);
        SemesterProvider semesterProvider = Provider.of<SemesterProvider>(
            context, listen: false);
        SessionProvider sessionProvider = Provider.of<SessionProvider>(
            context, listen: false);
        TeacherProvider teacherProvider = Provider.of<TeacherProvider>(
            context, listen: false);
        StudentProvider studentProvider = Provider.of<StudentProvider>(
            context, listen: false);
        SubjectProvider subjectProvider = Provider.of<SubjectProvider>(
            context, listen: false);
        UserTypeProvider userTypeProvider = Provider.of<UserTypeProvider>(
            context, listen: false);
        UserProvider userProvider = Provider.of<UserProvider>(
            context, listen: false);
        MembersProvider membersProvider = Provider.of<MembersProvider>(
            context, listen: false);
        PermissionProvider permissionProvider = Provider.of<PermissionProvider>(
            context, listen: false);
        LeaveTypeProvider leaveTypeProvider = Provider.of<LeaveTypeProvider>(
            context, listen: false);
        MenuManagementProvider menuManagementProvider = Provider.of<
            MenuManagementProvider>(context, listen: false);
        WeekProvider weekProvider = Provider.of<WeekProvider>(
            context, listen: false);
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
        setState(() {
          isLoading = false;
        });
      });
    } catch(e){
      setState(() {
        isLoading = false;
      });
      toastMessage(message: 'Server Error', colors: kRedColor);
    }
  }

  Future<bool> _onBackPressed() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: _selectedIndex == 0 ? AppBar(
          title: Text('Dashboard'),
          actions: [
            MaterialButton(
              color: kButtonColor,
              textColor: kBTextColor,
              shape: materialButtonDesign(),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => StaffFaceAttendance()));
              },
              child: Text('Staff Attendance'),
            ),
            IconButton(
              onPressed: (){
                _refreshIndicatorKey.currentState?.show();
              },
              icon: Icon(Icons.refresh),
            ),
            SizedBox(width: 10),
          ],
        ) : null,
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.white,
          backgroundColor: Colors.blue,
          strokeWidth: 4.0,
          onRefresh: () async {
            getHomePageData();
            return Future<void>.delayed(const Duration(seconds: 3));
          },
          child: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.cottage_outlined),
              activeIcon: Icon(Icons.cottage),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school),
              label: 'Academics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_available_outlined),
              activeIcon: Icon(Icons.event_available),
              label: 'Attendance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lan_outlined),
              activeIcon: Icon(Icons.lan),
              label: 'Human Resource',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: kMainColor,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
