import 'package:medical_college/Theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toastMessage({required String message, Color? colors}){
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: colors ?? kMainColor,
    textColor: kWhiteColor,
    fontSize: 16.0,
  );
}

class LoadingIcon extends StatelessWidget {
  const LoadingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: kMainColor));
    // return Center(child: Image.asset('images/khwahish_gif.gif'));
  }
}
