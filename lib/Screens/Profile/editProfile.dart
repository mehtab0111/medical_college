import 'dart:convert';
import 'dart:io';
import 'package:medical_college/Components/DialougBox/imagePickerPopUp.dart';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/localDatabase.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController mobile = TextEditingController();

  String genderValue = '';
  String uploadedImage = '';

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
          // dateOfJoining.text = '${picked.day}-${picked.month}-${picked.year}';
        });
      }
    }
  }

  File? _image;
  ImagePicker picker = ImagePicker();
  void pickImageFromCamera() async {
    var pickedImage = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedImage!.path);
    });
  }

  void pickImageFromGallery() async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedImage!.path);
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<String> getUserData() async {
    String url = APIData.getLoggedInUserData;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader);
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      firstName.text = jsonData['data']['first_name'];
      middleName.text = jsonData['data']['middle_name'] ?? '';
      lastName.text = jsonData['data']['last_name'];
      genderValue = jsonData['data']['gender'] != null ? jsonData['data']['gender'] == 'male' ? 'Male' :
      jsonData['data']['gender'] == 'female' ? 'Female' : '' : '';
      dob.text = jsonData['data']['dob'];
      mobile.text = jsonData['data']['mobile_no'] ?? '';
      if(jsonData['data']['image'] != null) {
        uploadedImage =
        '${jsonData['data']['img_url']}${jsonData['data']['image']}';
      }
      setState(() {});
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 75,
                    backgroundColor:Theme.of(context).scaffoldBackgroundColor != Colors.black ?
                    Colors.white : kDarkColor,
                    child: _image != null ? CircleAvatar(
                      radius: 70,
                      backgroundImage: FileImage(File(_image!.path)),
                    ) : uploadedImage == '' ? CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage('images/img_blank_profile.png'),
                    ) : CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(uploadedImage),
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.6),
                      radius: 20,
                      child: IconButton(
                        icon: Icon(Icons.edit_outlined),
                        color: Colors.white,
                        onPressed: (){
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
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              kSpace(),
              Column(
                children: [
                  KTextField(title: 'First Name', controller: firstName,),
                  KTextField(title: 'Middle Name', controller: middleName,),
                  KTextField(title: 'Last Name', controller: lastName,),
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
                    controller: mobile,
                    title: 'Mobile Number',
                    textLimit: 10,
                    textInputType: TextInputType.number,
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
                ],
              ),
              kSpace(),
              KButton(
                title: 'Save',
                onClick: (){
                  if (_formKey.currentState!.validate()) {
                    updateStudent(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> updateStudent(context) async {
    String url = APIData.updateStudent;
    var response = await http.post(Uri.parse(url), headers: APIData.kHeader,
      body: jsonEncode({
        "first_name": firstName.text,
        "middle_name": middleName.text,
        "last_name": lastName.text,
        "gender": genderValue,
        "dob": dob.text,
        "mobile_no": mobile.text,
      }),
    );
    if(response.statusCode == 200){
      toastMessage(message: 'Profile Updated');
      Navigator.pop(context);
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }
}
