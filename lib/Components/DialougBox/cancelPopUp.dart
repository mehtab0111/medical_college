import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';

Future<String?> cancelPopUp(BuildContext context, {required Function() onClickYes}) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: Text('Cancel Shift Request', style: kHeaderStyle()),
      content: Text('Are you sure you want to cancel this request?'),
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
