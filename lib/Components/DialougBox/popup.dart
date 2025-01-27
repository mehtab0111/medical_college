import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';

Future<String?> kPopUp(BuildContext context, {
  required String title,
  required String desc,
  required Function() onClickYes,
}) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: Text(title, style: kHeaderStyle()),
      content: Text(desc),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onClickYes,
          child: const Text('Yes'),
        ),
      ],
    ),
  );
}
