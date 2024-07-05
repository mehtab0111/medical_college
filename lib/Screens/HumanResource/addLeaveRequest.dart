import 'dart:io';

import 'package:medical_college/Components/DialougBox/imagePickerPopUp.dart';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/localDatabase.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddLeaveRequest extends StatefulWidget {
  const AddLeaveRequest({super.key});

  @override
  State<AddLeaveRequest> createState() => _AddLeaveRequestState();
}

class _AddLeaveRequestState extends State<AddLeaveRequest> {

  TextEditingController appleDate = TextEditingController();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();

  String roleValue = '';
  String leaveValue = '';
  String statusType = '';

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context, int dateType) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      if(dateType == 1) {
        setState(() {
          appleDate.text = '${picked.day}-${picked.month}-${picked.year}';
        });
      }
      if(dateType == 2) {
        setState(() {
          fromDate.text = '${picked.day}-${picked.month}-${picked.year}';
        });
      }
      if(dateType == 3) {
        setState(() {
          toDate.text = '${picked.day}-${picked.month}-${picked.year}';
        });
      }
    }
  }

  File? image;
  ImagePicker picker = ImagePicker();
  void pickImageFromCamera() async {
    var pickedImage = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      image = File(pickedImage!.path);
    });
  }

  void pickImageFromGallery() async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = File(pickedImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Leave Request'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: containerDesign(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text('Add Details', style: kHeaderStyle()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text('Role', style: kSmallText()),
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
                  KTextField(title: 'Name'),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text('Apply Date', style: kSmallText()),
                  ),
                  KTextField(
                    title: 'Apply Date',
                    controller: appleDate,
                    suffixButton: IconButton(
                      onPressed: (){
                        _selectDate(context, 1);
                      },
                      icon: Icon(Icons.calendar_month_outlined),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text('Leave Type', style: kSmallText()),
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
                            value: leaveValue != '' ? leaveValue : null,
                            hint: Text('Leave Type'),
                            items: ['', '']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                leaveValue = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text('Leave From Date', style: kSmallText()),
                  ),
                  KTextField(
                    title: 'Leave From Date',
                    controller: fromDate,
                    suffixButton: IconButton(
                      onPressed: (){
                        _selectDate(context, 2);
                      },
                      icon: Icon(Icons.calendar_month_outlined),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text('Leave To Date', style: kSmallText()),
                  ),
                  KTextField(
                    title: 'Leave To Date',
                    controller: toDate,
                    suffixButton: IconButton(
                      onPressed: (){
                        _selectDate(context, 3);
                      },
                      icon: Icon(Icons.calendar_month_outlined),
                    ),
                  ),
                  KTextField(title: 'Reason',),
                  KTextField(title: 'Note',),
                  IconMaterialButton(
                    iconData: Icons.file_upload_outlined,
                    title: image != null ? 'Change uploaded document' : 'Upload document',
                    onClick: (){
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context){
                          return ImagePickerPopUp(
                            onCameraClick: (){
                              Navigator.pop(context);
                              pickImageFromCamera();
                            },
                            onGalleryClick: (){
                              Navigator.pop(context);
                              pickImageFromGallery();
                            },
                          );
                        }
                      );
                    },
                  ),
                  Text('Status'.padLeft(10), style: kSmallText()),
                  Row(
                    children: [
                      radioButton(
                        iconData: statusType == 'Pending' ?
                        Icons.radio_button_checked : Icons.radio_button_off,
                        title: 'Pending',
                        onClick: (){
                          setState(() {
                            statusType = 'Pending';
                          });
                        },
                      ),
                      radioButton(
                        iconData: statusType == 'Approve' ?
                        Icons.radio_button_checked : Icons.radio_button_off,
                        title: 'Approve',
                        onClick: (){
                          setState(() {
                            statusType = 'Approve';
                          });
                        },
                      ),
                      radioButton(
                        iconData: statusType == 'DisApprove' ?
                        Icons.radio_button_checked : Icons.radio_button_off,
                        title: 'DisApprove',
                        onClick: (){
                          setState(() {
                            statusType = 'DisApprove';
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: KButton(
                      title: 'Save',
                      onClick: (){
                        Navigator.pop(context);
                        toastMessage(message: 'Request submitted');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
