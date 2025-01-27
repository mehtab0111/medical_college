import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';

Future<String?> deletePopUp(BuildContext context, {required Function() onClickYes}) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: Text('Delete Item', style: kHeaderStyle()),
      content: Text('Are you sure you want to delete this item?'),
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