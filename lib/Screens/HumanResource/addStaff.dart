import 'dart:io';

import 'package:medical_college/Components/DialougBox/imagePickerPopUp.dart';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/localDatabase.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddStaff extends StatefulWidget {
  const AddStaff({super.key});

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {

  TextEditingController staffID = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController fatherName = TextEditingController();
  TextEditingController motherName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController dateOfJoining = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController emgNumber = TextEditingController();
  TextEditingController currentAddress = TextEditingController();
  TextEditingController permanentAddress = TextEditingController();
  TextEditingController qualification = TextEditingController();
  TextEditingController experience = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController epfNo = TextEditingController();
  TextEditingController basicSalary = TextEditingController();
  TextEditingController workShift = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController sickLeave = TextEditingController();
  TextEditingController casualLeave = TextEditingController();
  TextEditingController studentLeave = TextEditingController();
  TextEditingController maternityLeave = TextEditingController();
  TextEditingController accountTitle = TextEditingController();
  TextEditingController bankAcNo = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController ifscCode = TextEditingController();
  TextEditingController bankBranchName = TextEditingController();
  TextEditingController facebookURL = TextEditingController();
  TextEditingController twitterURL = TextEditingController();
  TextEditingController linkedinURL = TextEditingController();
  TextEditingController instagramURL = TextEditingController();

  String roleValue = '';
  String designationValue = '';
  String departmentValue = '';
  String genderValue = '';
  String maritalValue = '';
  String contractValue = '';

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context, int dateType) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      if(dateType == 1){
        setState(() {
          dob.text = '${picked.day}-${picked.month}-${picked.year}';
        });
      }
      if(dateType == 2){
        setState(() {
          dateOfJoining.text = '${picked.day}-${picked.month}-${picked.year}';
        });
      }
    }
  }

  File? image;
  File? resumeImage;
  File? joiningLetterImage;
  File? documentImage;
  ImagePicker picker = ImagePicker();
  void pickImageFromCamera(String imageType) async {
    var pickedImage = await picker.pickImage(source: ImageSource.camera);
    if(imageType == 'user') {
      setState(() {
        image = File(pickedImage!.path);
      });
    }
    if(imageType == 'resume') {
      setState(() {
        resumeImage = File(pickedImage!.path);
      });
    }
    if(imageType == 'joining') {
      setState(() {
        joiningLetterImage = File(pickedImage!.path);
      });
    }
    if(imageType == 'document') {
      setState(() {
        documentImage = File(pickedImage!.path);
      });
    }
  }

  void pickImageFromGallery(String imageType) async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if(imageType == 'user') {
      setState(() {
        image = File(pickedImage!.path);
      });
    }
    if(imageType == 'resume') {
      setState(() {
        resumeImage = File(pickedImage!.path);
      });
    }
    if(imageType == 'joining') {
      setState(() {
        joiningLetterImage = File(pickedImage!.path);
      });
    }
    if(imageType == 'document') {
      setState(() {
        documentImage = File(pickedImage!.path);
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Staff'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                decoration: containerDesign(context),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text('Basic Information', style: kHeaderStyle()),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    KTextField(title: 'Staff ID', controller: staffID,),
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text('Role', style: kSmallText()),
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
                              value: roleValue != '' ? roleValue : null,
                              hint: Text('Role'),
                              items: roleList
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  roleValue = newValue!;
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
                        Text('Designation', style: kSmallText()),
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
                              value: designationValue != '' ? designationValue : null,
                              hint: Text('Designation'),
                              items: designationList
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  designationValue = newValue!;
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
                        Text('Department', style: kSmallText()),
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
                              value: departmentValue != '' ? departmentValue : null,
                              hint: Text('Department'),
                              items: departmentList
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  departmentValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    KTextField(title: 'First Name', controller: firstName,),
                    KTextField(title: 'Last Name', controller: lastName,),
                    KTextField(title: 'Father Name', controller: fatherName,),
                    KTextField(title: 'Mother Name', controller: motherName,),
                    KTextField(
                      controller: email,
                      title: 'Email',
                      textInputType: TextInputType.emailAddress,
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text('Gender', style: kSmallText()),
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
                              value: genderValue != '' ? genderValue : null,
                              hint: Text('Gender'),
                              items: genderList
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  genderValue = newValue!;
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
                        Text('Date Of Birth', style: kSmallText()),
                      ],
                    ),
                    KTextField(
                      readOnly: true,
                      controller: dob,
                      title: 'Date Of Birth',
                      suffixButton: IconButton(
                        onPressed: (){
                          _selectDate(context, 1);
                        },
                        icon: Icon(Icons.calendar_month_outlined),
                      ),
                    ),
                    KTextField(
                      title: 'Date Of Joining',
                      controller: dateOfJoining,
                      suffixButton: IconButton(
                        onPressed: (){
                          _selectDate(context, 2);
                        },
                        icon: Icon(Icons.calendar_month_outlined),
                      ),
                    ),
                    KTextField(
                      controller: mobile,
                      title: 'Mobile Number',
                      textLimit: 10,
                      textInputType: TextInputType.number,
                    ),
                    KTextField(
                      controller: emgNumber,
                      title: 'Emergency Contact Number',
                      textLimit: 10,
                      textInputType: TextInputType.number,
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text('Marital Status', style: kSmallText()),
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
                              value: maritalValue != '' ? maritalValue : null,
                              hint: Text('Marital Status'),
                              items: maritalList
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  maritalValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconMaterialButton(
                      iconData: Icons.file_upload_outlined,
                      title: image != null ? 'Change Photo' : 'Upload Photo',
                      onClick: (){
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context){
                            return ImagePickerPopUp(
                              onCameraClick: (){
                                Navigator.pop(context);
                                pickImageFromCamera('user');
                              },
                              onGalleryClick: (){
                                Navigator.pop(context);
                                pickImageFromGallery('user');
                              },
                            );
                          },
                        );
                      },
                    ),
                    KTextField(title: 'Current Address', controller: currentAddress,),
                    KTextField(title: 'Permanent Address', controller: permanentAddress,),
                    KTextField(title: 'Qualification', controller: qualification,),
                    KTextField(title: 'Work Experience', controller: experience,),
                    KTextField(title: 'Note', controller: note,),
                  ],
                ),
              ),
              // SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                decoration: containerDesign(context),
                child: Column(
                  children: [
                    SizedBox(height: 5.0),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: ExpansionTile(
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        title: Text('Add More Details', style: kHeaderStyle()),
                        children: [
                          SizedBox(height: 10.0),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('Payroll', style: kHeaderStyle()),
                          ),
                          KTextField(title: 'EPF No', controller: epfNo,),
                          KTextField(title: 'Basic Salary', controller: basicSalary,),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('Contract Type', style: kSmallText(),),
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
                                    value: contractValue != '' ? contractValue : null,
                                    hint: Text('Contract Type'),
                                    items: ['Permanent', 'Probation']
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        contractValue = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          KTextField(title: 'Work Shift', controller: workShift,),
                          KTextField(title: 'Location', controller: location,),
                          SizedBox(height: 10.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text('Leaves', style: kHeaderStyle()),
                          ),
                          KTextField(title: 'Sick Leave', controller: sickLeave,),
                          KTextField(title: 'Casual Leave', controller: casualLeave,),
                          KTextField(title: 'Student Leave', controller: studentLeave,),
                          KTextField(title: 'Maternity Leave', controller: maternityLeave,),
                          SizedBox(height: 10.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text('Bank Account Details', style: kHeaderStyle()),
                          ),
                          KTextField(title: 'Account Title', controller: accountTitle,),
                          KTextField(title: 'Bank Account Number', controller: bankAcNo,),
                          KTextField(title: 'Bank Name', controller: bankName,),
                          KTextField(title: 'IFSC Code', controller: ifscCode,),
                          KTextField(title: 'Bank Branch Name', controller: bankBranchName,),
                          SizedBox(height: 10.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text('Social Media Link', style: kHeaderStyle()),
                          ),
                          SizedBox(height: 5.0),
                          KTextField(title: 'Facebook URL', controller: facebookURL,),
                          KTextField(title: 'Twitter URL', controller: twitterURL,),
                          KTextField(title: 'Linkedin URL', controller: linkedinURL,),
                          KTextField(title: 'Instagram URL', controller: instagramURL,),
                          SizedBox(height: 10.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text('Upload Documents', style: kHeaderStyle()),
                          ),
                          IconMaterialButton(
                            iconData: Icons.file_upload_outlined,
                            title: resumeImage != null ? 'Change Resume' : 'Upload Resume',
                            onClick: (){
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context){
                                  return ImagePickerPopUp(
                                    onCameraClick: (){
                                      Navigator.pop(context);
                                      pickImageFromCamera('resume');
                                    },
                                    onGalleryClick: (){
                                      Navigator.pop(context);
                                      pickImageFromGallery('resume');
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          IconMaterialButton(
                            iconData: Icons.file_upload_outlined,
                            title: joiningLetterImage != null ? 'Change joining letter' : 'Upload joining letter',
                            onClick: (){
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context){
                                  return ImagePickerPopUp(
                                    onCameraClick: (){
                                      Navigator.pop(context);
                                      pickImageFromCamera('joining');
                                    },
                                    onGalleryClick: (){
                                      Navigator.pop(context);
                                      pickImageFromGallery('joining');
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          IconMaterialButton(
                            iconData: Icons.file_upload_outlined,
                            title: documentImage != null ? 'Change document Image' : 'Upload Document Image',
                            onClick: (){
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context){
                                  return ImagePickerPopUp(
                                    onCameraClick: (){
                                      Navigator.pop(context);
                                      pickImageFromCamera('document');
                                    },
                                    onGalleryClick: (){
                                      Navigator.pop(context);
                                      pickImageFromGallery('document');
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: 5.0),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.0),
                    KButton(
                      title: 'Save',
                      onClick: (){
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

