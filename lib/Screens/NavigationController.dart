import 'package:medical_college/Components/DialougBox/logoutPopUp.dart';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Screens/Attendance/attendance.dart';
import 'package:medical_college/Screens/Auth/loginPage.dart';
import 'package:medical_college/Screens/Academics/academics.dart';
import 'package:medical_college/Screens/Home/homePage.dart';
import 'package:medical_college/Screens/HumanResource/humanResource.dart';
import 'package:medical_college/Screens/Profile/editProfile.dart';
import 'package:medical_college/Screens/Reports/reportsPage.dart';
import 'package:medical_college/Screens/Settings/settings.dart';
import 'package:medical_college/Screens/StudentInformation/studentInformation.dart';
import 'package:medical_college/Screens/Profile/profilePage.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';

class NavigationController extends StatefulWidget {
  const NavigationController({super.key});

  @override
  State<NavigationController> createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget bodyWidget = HomePage();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBackgroundDesign(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: (){
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('images/img_blank_profile.png'),
              ),
            ),
          ),
          title: Image.asset('images/noBGLogo.jpg', height: 40),
          actions: [
            IconButton(
              onPressed: (){
                logoutBuilder(context);
              },
              icon: Icon(Icons.logout_outlined),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // navigateButton(
              //   context,
              //   leftTitle: 'Dashboard',
              //   leftIcon: Icons.widgets_outlined,
              //   onLeftBClick: (){
              //     Navigator.push(context, MaterialPageRoute(
              //         builder: (context) => HomePage()));
              //   },
              //   rightTitle: 'Academics',
              //   rightIcon: Icons.school_outlined,
              //   onRightBClick: (){
              //     Navigator.push(context, MaterialPageRoute(
              //         builder: (context) => Academics()));
              //   },
              // ),
              // navigateButton(
              //   context,
              //   leftTitle: 'Attendance',
              //   leftIcon: Icons.event_available_outlined,
              //   onLeftBClick: (){
              //     Navigator.push(context, MaterialPageRoute(
              //         builder: (context) => Attendance()));
              //   },
              //   rightTitle: 'Human Resource',
              //   rightIcon: Icons.lan_outlined,
              //   onRightBClick: (){
              //     Navigator.push(context, MaterialPageRoute(
              //         builder: (context) => HumanResource()));
              //   },
              // ),
              tileButton(
                context,
                leadingIcon: Icons.double_arrow_outlined,
                title: 'Student Information',
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => StudentInformation()));
                },
              ),
              tileButton(
                context,
                leadingIcon: Icons.double_arrow_outlined,
                title: 'Reports',
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ReportsPage()));
                },
              ),
              tileButton(
                context,
                leadingIcon: Icons.double_arrow_outlined,
                title: 'Settings',
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Settings()));
                },
              ),
              // navigateButton(
              //   context,
              //   leftTitle: 'Student Information',
              //   leftIcon: Icons.person_add,
              //   onLeftBClick: (){
              //     Navigator.push(context, MaterialPageRoute(builder: (context) => StudentInformation()));
              //   },
              //   rightTitle: 'Reports',
              //   rightIcon: Icons.assignment_outlined,
              //   onRightBClick: (){
              //     Navigator.push(context, MaterialPageRoute(builder: (context) => ReportsPage()));
              //   },
              // ),
              // navigateButton(
              //   context,
              //   leftTitle: 'Settings',
              //   leftIcon: Icons.settings_outlined,
              //   onLeftBClick: (){
              //     Navigator.push(context, MaterialPageRoute(
              //         builder: (context) => Settings()));
              //   },
              //   rightTitle: '',
              //   rightIcon: Icons.settings_outlined,
              //   onRightBClick: (){},
              // ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile kDrawerButton(BuildContext context, {
    IconData? iconData,
    required String title,
    required Widget bodyWidgetPage,
  }) {
    return ListTile(
      leading: Icon(iconData,
        color: Theme.of(context).scaffoldBackgroundColor != Colors.black ? Colors.black : kWhiteColor,
      ),
      title: Text(title),
      onTap: (){
        setState(() {
          bodyWidget = bodyWidgetPage;
        });
        Navigator.pop(context);
      },
      trailing: Icon(Icons.chevron_right_outlined,
        color: Theme.of(context).scaffoldBackgroundColor != Colors.black ? Colors.black : kWhiteColor),
    );
  }
}

Container navigateButton(BuildContext context, {
  required String leftTitle,
  IconData? leftIcon,
  required String rightTitle,
  IconData? rightIcon,
  required Function() onLeftBClick,
  required Function() onRightBClick,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 5.0),
    height: MediaQuery.of(context).size.width*0.5,
    child: Row(
      children: [
        KIconButton(
          onClick: onLeftBClick,
          iconData: leftIcon,
          title: leftTitle,
          color: k3Color,
        ),
        rightTitle != '' ?
        KIconButton(
          onClick: onRightBClick,
          iconData: rightIcon,
          title: rightTitle,
          color: k4Color,
        ) : Expanded(child: Container()),
      ],
    ),
  );
}
