import 'dart:io';

import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/localDatabase.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({super.key});

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {

  TextEditingController schoolName = TextEditingController();
  TextEditingController schoolCode = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController devices = TextEditingController();
  TextEditingController admissionNoPrefix = TextEditingController();
  TextEditingController admissionNoDigit = TextEditingController();
  TextEditingController admissionStartFrom = TextEditingController();
  TextEditingController staffIDPrefix = TextEditingController();
  TextEditingController staffNoDigit = TextEditingController();
  TextEditingController staffIDStartFrom = TextEditingController();
  TextEditingController feesDueDate = TextEditingController();
  TextEditingController mobileAppAPIURL = TextEditingController();
  TextEditingController mobileAppPrimaryColor = TextEditingController();
  TextEditingController mobileAppSecondaryColor = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();

  String sessionValue = '';
  String startMonthValue = '';
  String languageValue = '';
  String dateFormValue = '';
  String timezoneValue = '';
  String startDayValue = '';
  int attendanceType = 0;
  int bioAttendanceType = 0;
  bool languageRTLEnabled = false;
  bool admissionNoEnabled = false;
  bool autoStaffIDEnabled = false;
  bool showMyQuesEnabled = false;
  bool duplicateFeeEnabled = false;
  bool teacherRestrictedModeEnabled = false;

  File? printLogoImage;
  File? adminLogoImage;
  File? adminSmallLogo;
  File? appLogoImage;
  void pickImageFromGallery(String imageType) async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if(imageType == 'printLogo') {
      setState(() {
        printLogoImage = File(pickedImage!.path);
      });
    }
    if(imageType == 'adminLogo') {
      setState(() {
        adminLogoImage = File(pickedImage!.path);
      });
    }
    if(imageType == 'adminSmallLogo') {
      setState(() {
        adminSmallLogo = File(pickedImage!.path);
      });
    }
    if(imageType == 'appLogo') {
      setState(() {
        appLogoImage = File(pickedImage!.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('General Settings'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: containerDesign(context),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KTextField(title: 'School Name', controller: schoolName,),
                    KTextField(title: 'School Code', controller: schoolCode,),
                    KTextField(title: 'Address', controller: address,),
                    KTextField(title: 'Phone', controller: phone,),
                    KTextField(title: 'Email', controller: email,),
                    Divider(thickness: 1),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Session', style: kHeaderStyle()),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        decoration: dropTextFieldDesign(),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(10.0),
                              value: sessionValue != '' ? sessionValue : null,
                              hint: Text('Session'),
                              items: sessionList
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  sessionValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text('Session Start Month', style: kSmallText()),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        decoration: dropTextFieldDesign(),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(10.0),
                              value: startMonthValue != '' ? startMonthValue : null,
                              hint: Text('Session Start Month '),
                              items: ['June', 'July', 'August']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  startMonthValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(thickness: 1),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Attendance Type', style: kHeaderStyle()),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Attendance', style: kSmallText()),
                    ),
                    Row(
                      children: [
                        radioButton(
                          iconData: attendanceType == 1 ? Icons.radio_button_checked : Icons.radio_button_off,
                          title: 'Daily Wise',
                          onClick: (){
                            setState(() {
                              attendanceType = 1;
                            });
                          },
                        ),
                        radioButton(
                          iconData: attendanceType == 2 ? Icons.radio_button_checked : Icons.radio_button_off,
                          title: 'Period Wise',
                          onClick: (){
                            setState(() {
                              attendanceType = 2;
                            });
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Biometric Attendance', style: kSmallText()),
                    ),
                    Row(
                      children: [
                        radioButton(
                          iconData: bioAttendanceType == 1 ? Icons.radio_button_checked : Icons.radio_button_off,
                          title: 'Disabled',
                          onClick: (){
                            setState(() {
                              bioAttendanceType = 1;
                            });
                          },
                        ),
                        radioButton(
                          iconData: bioAttendanceType == 2 ? Icons.radio_button_checked : Icons.radio_button_off,
                          title: 'Enabled',
                          onClick: (){
                            setState(() {
                              bioAttendanceType = 2;
                            });
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Devices (Separate By Coma)', style: kSmallText()),
                    ),
                    KTextField(
                      title: 'Devices (Separate By Coma)',
                      controller: devices,
                    ),
                    Divider(thickness: 1),
                    Text('Language'.padLeft(10), style: kHeaderStyle()),
                    SizedBox(height: 5.0),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        decoration: dropTextFieldDesign(),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(10.0),
                              value: languageValue != '' ? languageValue : null,
                              hint: Text('Language'),
                              items: ['', 'English']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  languageValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Language RTL Text Mode', style: kSmallText()),
                    ),
                    Row(
                      children: [
                        radioButton(
                          iconData: languageRTLEnabled != false ? Icons.radio_button_off : Icons.radio_button_checked,
                          title: 'Disabled',
                          onClick: (){
                            setState(() {
                              languageRTLEnabled = false;
                            });
                          },
                        ),
                        radioButton(
                          iconData: languageRTLEnabled != true ? Icons.radio_button_off : Icons.radio_button_checked,
                          title: 'Enabled',
                          onClick: (){
                            setState(() {
                              languageRTLEnabled = true;
                            });
                          },
                        ),
                      ],
                    ),
                    Divider(thickness: 1),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text('Date Time', style: kHeaderStyle()),
                    ),
                    SizedBox(height: 5.0),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Date Format', style: kSmallText()),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        decoration: dropTextFieldDesign(),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(10.0),
                              value: dateFormValue != '' ? dateFormValue : null,
                              hint: Text('Date Format'),
                              items: ['dd-mm-yyyy', 'dd/mm/yyyy', 'mm/dd/yyyy']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dateFormValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Timezone', style: kSmallText()),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        decoration: dropTextFieldDesign(),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(10.0),
                              value: timezoneValue != '' ? timezoneValue : null,
                              hint: Text('Time zone'),
                              items: ['Asia', 'Kolkata']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  timezoneValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Start day of week', style: kSmallText()),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        decoration: dropTextFieldDesign(),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(10.0),
                              value: startDayValue != '' ? startDayValue : null,
                              hint: Text('Start day of week'),
                              items: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  startDayValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(thickness: 1),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text('Student Admission No. Auto Generation', style: kHeaderStyle()),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Admission No', style: kSmallText()),
                    ),
                    Row(
                      children: [
                        radioButton(
                          iconData: admissionNoEnabled == false ? Icons.radio_button_checked : Icons.radio_button_off,
                          title: 'Disabled',
                          onClick: (){
                            setState(() {
                              admissionNoEnabled = false;
                            });
                          },
                        ),
                        radioButton(
                          iconData: admissionNoEnabled == true ? Icons.radio_button_checked : Icons.radio_button_off,
                          title: 'Enabled',
                          onClick: (){
                            setState(() {
                              admissionNoEnabled = true;
                            });
                          },
                        ),
                      ],
                    ),
                    KTextField(
                      title: 'Admission No Prefix',
                      controller: admissionNoPrefix,
                    ),
                    KTextField(
                      title: 'Admission No Digit',
                      controller: admissionNoDigit,
                      textInputType: TextInputType.number,
                    ),
                    KTextField(
                      title: 'Admission Start From',
                      controller: admissionStartFrom,
                    ),
                    Divider(thickness: 1),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Staff ID Auto Generation', style: kHeaderStyle()),
                    ),
                    SizedBox(height: 5.0),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Auto Staff ID', style: kSmallText()),
                    ),
                    Row(
                      children: [
                        radioButton(
                          iconData: autoStaffIDEnabled == false ? Icons.radio_button_checked : Icons.radio_button_off,
                          title: 'Disabled',
                          onClick: (){
                            setState(() {
                              autoStaffIDEnabled = false;
                            });
                          },
                        ),
                        radioButton(
                          iconData: autoStaffIDEnabled == true ? Icons.radio_button_checked : Icons.radio_button_off,
                          title: 'Enabled',
                          onClick: (){
                            setState(() {
                              autoStaffIDEnabled = true;
                            });
                          },
                        ),
                      ],
                    ),
                    KTextField(
                      title: 'Staff ID Prefix',
                      controller: staffIDPrefix,
                    ),
                    KTextField(
                      title: 'Staff No Digit',
                      controller: staffNoDigit,
                    ),
                    KTextField(
                      title: 'Staff ID Start From',
                      controller: staffIDStartFrom,
                    ),
                    Divider(thickness: 1),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Online Examination', style: kHeaderStyle()),
                    ),
                    SizedBox(height: 5.0),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Show me only my question', style: kSmallText()),
                    ),
                    Row(
                      children: [
                        radioButton(
                          iconData: showMyQuesEnabled == false ? Icons.radio_button_checked : Icons.radio_button_off,
                          title: 'Disabled',
                          onClick: (){
                            setState(() {
                              showMyQuesEnabled = false;
                            });
                          },
                        ),
                        radioButton(
                          iconData: showMyQuesEnabled == true ? Icons.radio_button_checked : Icons.radio_button_off,
                          title: 'Enabled',
                          onClick: (){
                            setState(() {
                              showMyQuesEnabled = true;
                            });
                          },
                        ),
                      ],
                    ),
                    Divider(thickness: 1),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Miscellaneous', style: kHeaderStyle()),
                    ),
                    SizedBox(height: 5.0),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Duplicate Fees Invoice', style: kSmallText()),
                    ),
                    Row(
                      children: [
                        radioButton(
                          iconData: duplicateFeeEnabled == false ? Icons.radio_button_checked : Icons.radio_button_off,
                          title: 'Disabled',
                          onClick: (){
                            setState(() {
                              duplicateFeeEnabled = false;
                            });
                          },
                        ),
                        radioButton(
                          iconData: duplicateFeeEnabled == true ? Icons.radio_button_checked : Icons.radio_button_off,
                          title: 'Enabled',
                          onClick: (){
                            setState(() {
                              duplicateFeeEnabled = true;
                            });
                          },
                        ),
                      ],
                    ),
                    KTextField(
                      title: 'Fees Due Days ',
                      textInputType: TextInputType.number,
                      controller: feesDueDate,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Teacher Restricted Mode', style: kSmallText()),
                    ),
                    Row(
                      children: [
                        radioButton(
                          iconData: teacherRestrictedModeEnabled == false ? Icons.radio_button_checked : Icons.radio_button_off,
                          title: 'Disabled',
                          onClick: (){
                            setState(() {
                              teacherRestrictedModeEnabled = false;
                            });
                          },
                        ),
                        radioButton(
                          iconData: teacherRestrictedModeEnabled == true ? Icons.radio_button_checked : Icons.radio_button_off,
                          title: 'Enabled',
                          onClick: (){
                            setState(() {
                              teacherRestrictedModeEnabled = true;
                            });
                          },
                        ),
                      ],
                    ),
                    Divider(thickness: 1),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Mobile App', style: kHeaderStyle()),
                    ),
                    SizedBox(height: 5.0),
                    KTextField(
                      title: 'Mobile App API URL',
                      controller: mobileAppAPIURL,
                    ),
                    KTextField(
                      title: 'Mobile App Primary Color Code',
                      controller: mobileAppPrimaryColor,
                    ),
                    KTextField(
                      title: 'Mobile App Secondary Color Code',
                      controller: mobileAppSecondaryColor,
                    ),
                    IconMaterialButton(
                      iconData: Icons.file_upload_outlined,
                      title: 'Edit Print Logo',
                      onClick: (){
                        pickImageFromGallery('printLogo');
                      },
                    ),
                    IconMaterialButton(
                      iconData: Icons.file_upload_outlined,
                      title: 'Edit Admin Logo',
                      onClick: (){
                        pickImageFromGallery('adminLogo');
                      },
                    ),
                    IconMaterialButton(
                      iconData: Icons.file_upload_outlined,
                      title: 'Edit Admin Small Logo',
                      onClick: (){
                        pickImageFromGallery('adminSmallLogo');
                      },
                    ),
                    IconMaterialButton(
                      iconData: Icons.file_upload_outlined,
                      title: 'Edit App Logo',
                      onClick: (){
                        pickImageFromGallery('appLogo');
                      },
                    ),
                    SizedBox(height: 5.0),
                    Center(
                      child: KButton(
                        title: 'Save',
                        onClick: (){
                          if(_formKey.currentState!.validate()){

                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
