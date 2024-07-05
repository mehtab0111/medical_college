import 'package:medical_college/Screens/Auth/loginPage.dart';
import 'package:medical_college/Services/serviceManager.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';

Future<String?> logoutBuilder(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: Text('Logout', style: kHeaderStyle()),
      content: Text('Are you sure you want to logout?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: (){
            ServiceManager().removeAll();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) => LoginPage()), (route) => false);
          },
          child: const Text('Yes'),
        ),
      ],
    ),
  );
}
