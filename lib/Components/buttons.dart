import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';

class KButton extends StatelessWidget {

  String title;
  Function() onClick;
  Color? color;
  KButton({Key? key, required this.title, required this.onClick, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: MediaQuery.of(context).size.width*0.8,
      shape: materialButtonDesign(),
      color: color ?? k2MainColor,
      textColor: kBTextColor,
      onPressed: onClick,
      child: Text(title),
    );
  }
}

class LoadingButton extends StatelessWidget {

  Color? color;
  LoadingButton({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: MediaQuery.of(context).size.width*0.8,
      shape: materialButtonDesign(),
      color: color ?? k2MainColor,
      textColor: kBTextColor,
      onPressed: (){},
      child: CircularProgressIndicator(
        color: kWhiteColor,
      ),
    );
  }
}

class LoginButton extends StatelessWidget {

  String title, image;
  Function() onClick;
  LoginButton({required this.title, required this.image, required this.onClick,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 45,
      color: kMainColor,
      textColor: kWhiteColor,
      shape: materialButtonDesign(),
      minWidth: MediaQuery.of(context).size.width*0.8,
      onPressed: onClick,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title),
          SizedBox(width: 10.0),
          Image.asset(image, height: 25),
        ],
      ),
    );
  }
}

Widget tileButton(BuildContext context, {required IconData leadingIcon,
  required String title,
  required Function() onClick,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
    child: Container(
      // decoration: roundedContainerDesign(context),
      decoration: blurCurveDecor(context),
      child: ListTile(
        leading: Icon(leadingIcon, color: Theme.of(context).scaffoldBackgroundColor != Colors.black ? kMainColor : kWhiteColor),
        title: Text(title),
        trailing: Icon(Icons.chevron_right_outlined, color: Theme.of(context).scaffoldBackgroundColor != Colors.black ? kMainColor : kWhiteColor),
        onTap: onClick,
      ),
    ),
  );
}

class KIconButton extends StatelessWidget {

  Function() onClick;
  IconData? iconData;
  String title;
  Color? color;
  KIconButton({
    super.key,
    required this.onClick,
    this.iconData,
    required this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: InkWell(
          onTap: onClick,
          child: Container(
            decoration: roundedContainerDesign(context).copyWith(
              color: color,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(iconData != null)
                Icon(iconData, size: 40.0, color: kWhiteColor),
                SizedBox(height: 10.0),
                Text(title,
                  style: kWhiteTextStyle(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

MaterialButton radioButton({required IconData iconData, required String title, required Function() onClick}) {
  return MaterialButton(
    onPressed: onClick,
    child: Row(
      children: [
        Icon(iconData),
        SizedBox(width: 10.0),
        Text(title),
      ],
    ),
  );
}

class IconMaterialButton extends StatelessWidget {

  IconData iconData;
  String title;
  Function() onClick;
  Color? color;
  IconMaterialButton({
    required this.iconData,
    required this.title,
    required this.onClick,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: MaterialButton(
        height: 45,
        color: color ?? kButtonColor,
        textColor: kWhiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: onClick,
        child: Row(
          children: [
            Icon(iconData),
            SizedBox(width: 10.0),
            Text(title),
          ],
        ),
      ),
    );
  }
}
