import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Screens/Settings/generalSettings.dart';
import 'package:medical_college/Screens/Settings/roles.dart';
import 'package:medical_college/Screens/Settings/users.dart';
import 'package:medical_college/provider/menuManagement_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    final menuManagementProvider = Provider.of<MenuManagementProvider>(context);
    bool roleAndPermission = false;
    for(var permission in menuManagementProvider.menuManagementList){
      print(permission.permission);
      if(permission.name == 'Roles And Permission'){
        roleAndPermission = permission.permission;
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // tileButton(
            //   context,
            //   leadingIcon: Icons.double_arrow,
            //   title: 'General Settings',
            //   onClick: (){
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => GeneralSettings()));
            //   },
            // ),
            if(roleAndPermission != false)
            tileButton(
              context,
              leadingIcon: Icons.double_arrow,
              title: 'Roles',
              onClick: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => RolesAndPermission()));
              },
            ),
            tileButton(
              context,
              leadingIcon: Icons.double_arrow,
              title: 'Users',
              onClick: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Users()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
