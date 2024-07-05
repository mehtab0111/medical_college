import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:medical_college/Components/DialougBox/imagePickerPopUp.dart';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/localDatabase.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/model/agent_model.dart';
import 'package:medical_college/model/cast_model.dart';
import 'package:medical_college/model/franchise_model.dart';
import 'package:medical_college/provider/course_provider.dart';
import 'package:medical_college/provider/semester_provider.dart';
import 'package:medical_college/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class EditStudent extends StatefulWidget {
  const EditStudent({super.key});

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController studentID = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController admissionDate = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController emgMobile = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController currentAddress = TextEditingController();
  TextEditingController permanentAddress = TextEditingController();
  TextEditingController rollNo = TextEditingController();
  TextEditingController registrationNo = TextEditingController();
  TextEditingController paymentDate = TextEditingController();
  TextEditingController transactionID = TextEditingController();
  TextEditingController cautionMoney = TextEditingController();

  TextEditingController fatherName = TextEditingController();
  TextEditingController fatherPhone = TextEditingController();
  TextEditingController fatherOccupation = TextEditingController();
  TextEditingController motherName = TextEditingController();
  TextEditingController motherPhone = TextEditingController();
  TextEditingController motherOccupation = TextEditingController();
  TextEditingController guardianName = TextEditingController();
  TextEditingController guardianRelation = TextEditingController();
  TextEditingController guardianEmail = TextEditingController();
  TextEditingController guardianPhone = TextEditingController();
  TextEditingController guardianOccupation = TextEditingController();
  TextEditingController guardianAddress = TextEditingController();

  String maritalValue = '';
  String agentValue = '';
  String religionValue = '';
  String castValue = '';
  String franchiseValue = '';
  String paymentModeValue = '';
  String courseValue = '';
  String semesterValue = '';
  String sessionValue = '';
  String genderValue = '';
  String bloodValue = '';

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context, int dateType) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      if(dateType == 1){
        setState(() {
          dob.text = '${picked.day}-${picked.month}-${picked.year}';
        });
      }
      if(dateType == 2){
        setState(() {
          admissionDate.text = '${picked.day}-${picked.month}-${picked.year}';
        });
      }
      if(dateType == 3){
        setState(() {
          paymentDate.text = '${picked.day}-${picked.month}-${picked.year}';
        });
      }
    }
  }

  File? dobCertificateImage;
  File? admissionSlip;
  File? studentImage;
  File? labReportImage;
  File? aadhaarCard;
  File? registrationCertificate;
  File? fatherIncomeCertificateImage;
  File? motherIncomeCertificateImage;
  ImagePicker picker = ImagePicker();
  void pickImageFromCamera(String imageType) async {
    var pickedImage = await picker.pickImage(source: ImageSource.camera);
    if(imageType == 'dob') {
      setState(() {
        dobCertificateImage = File(pickedImage!.path);
      });
    }
    if(imageType == 'admissionSlip') {
      setState(() {
        admissionSlip = File(pickedImage!.path);
      });
    }
    if(imageType == 'Student') {
      setState(() {
        studentImage = File(pickedImage!.path);
      });
    }
    if(imageType == 'labReport') {
      setState(() {
        labReportImage = File(pickedImage!.path);
      });
    }
    if(imageType == 'aadhaarCard') {
      setState(() {
        aadhaarCard = File(pickedImage!.path);
      });
    }
    if(imageType == 'registration') {
      setState(() {
        registrationCertificate = File(pickedImage!.path);
      });
    }
    if(imageType == 'Father') {
      setState(() {
        fatherIncomeCertificateImage = File(pickedImage!.path);
      });
    }
    if(imageType == 'Mother') {
      setState(() {
        motherIncomeCertificateImage = File(pickedImage!.path);
      });
    }
  }

  void pickImageFromGallery(String imageType) async {
    var pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if(imageType == 'dob') {
      setState(() {
        dobCertificateImage = File(pickedImage!.path);
      });
    }
    if(imageType == 'admissionSlip') {
      setState(() {
        admissionSlip = File(pickedImage!.path);
      });
    }
    if(imageType == 'Student') {
      setState(() {
        studentImage = File(pickedImage!.path);
      });
    }
    if(imageType == 'labReport') {
      setState(() {
        labReportImage = File(pickedImage!.path);
      });
    }
    if(imageType == 'aadhaarCard') {
      setState(() {
        aadhaarCard = File(pickedImage!.path);
      });
    }
    if(imageType == 'registration') {
      setState(() {
        registrationCertificate = File(pickedImage!.path);
      });
    }
    if(imageType == 'Father') {
      setState(() {
        fatherIncomeCertificateImage = File(pickedImage!.path);
      });
    }
    if(imageType == 'Mother') {
      setState(() {
        motherIncomeCertificateImage = File(pickedImage!.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAgent();
    getCategory();
    getFranchise();
  }

  List<Agent> agentList = [];
  Future<String> getAgent() async {
    String url = APIData.getAgent;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader);
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      for(var item in jsonData['data']){
        agentList.add(
          Agent(
            id: item['id'],
            identificationNo: item['identification_no'],
            firstName: item['first_name'],
            middleName: item['middle_name'] ?? '',
            lastName: item['last_name'],
          ),
        );
      }
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  List<Cast> castList = [];
  Future<String> getCategory() async {
    String url = APIData.getCategory;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader);
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      for(var item in jsonData['data']){
        castList.add(
          Cast(
            id: item['id'],
            name: item['name'],
          ),
        );
      }
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  List<FranchiseModel> franchiseList = [];
  Future<String> getFranchise() async {
    String url = APIData.getFranchise;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader);
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      for(var item in jsonData['data']){
        print(item);
        franchiseList.add(
          FranchiseModel(
            id: item['id'],
            name: item['name'],
            status: item['status'] == 1 ? true : false,
          ),
        );
      }
      // print(jsonData);
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  @override
  Widget build(BuildContext context) {
    var courseProvider = Provider.of<CourseProvider>(context);
    var semesterProvider = Provider.of<SemesterProvider>(context);
    var sessionProvider = Provider.of<SessionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Student'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: containerDesign(context),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    KTextField(
                      title: 'Student ID',
                      controller: studentID,
                      validate: (value){
                        return null;
                      },
                    ),
                    KTextField(title: 'First Name', controller: firstName,),
                    KTextField(
                      title: 'Middle Name',
                      controller: middleName,
                      validate: (value){
                        return null;
                      },
                    ),
                    KTextField(title: 'Last Name', controller: lastName,),
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
                      onClick: (){
                        _selectDate(context, 1);
                      },
                      suffixButton: Icon(Icons.calendar_month_outlined),
                    ),
                    IconMaterialButton(
                      iconData: Icons.file_upload_outlined,
                      title: dobCertificateImage != null ? 'Change Date Of Birth Proof' : 'Upload Date Of Birth Proof',
                      onClick: (){
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context){
                            return ImagePickerPopUp(
                              onCameraClick: (){
                                Navigator.pop(context);
                                pickImageFromCamera('dob');
                              },
                              onGalleryClick: (){
                                Navigator.pop(context);
                                pickImageFromGallery('dob');
                              },
                            );
                          },
                        );
                      },
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text('Admission Date', style: kSmallText()),
                      ],
                    ),
                    KTextField(
                      readOnly: true,
                      controller: admissionDate,
                      title: 'Admission Date',
                      onClick: (){
                        _selectDate(context, 2);
                      },
                      suffixButton: Icon(Icons.calendar_month_outlined),
                    ),
                    IconMaterialButton(
                      iconData: Icons.file_upload_outlined,
                      title: admissionSlip != null ? 'Change Admission Slip' : 'Upload Admission Slip',
                      onClick: (){
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context){
                            return ImagePickerPopUp(
                              onCameraClick: (){
                                Navigator.pop(context);
                                pickImageFromCamera('admissionSlip');
                              },
                              onGalleryClick: (){
                                Navigator.pop(context);
                                pickImageFromGallery('admissionSlip');
                              },
                            );
                          },
                        );
                      },
                    ),
                    KTextField(
                      controller: mobile,
                      title: 'Mobile Number',
                      textLimit: 10,
                      textInputType: TextInputType.number,
                    ),
                    KTextField(
                      controller: emgMobile,
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
                    IconMaterialButton(
                      iconData: Icons.file_upload_outlined,
                      title: studentImage != null ? 'Change Student Photo' : 'Upload Student Photo',
                      onClick: (){
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context){
                            return ImagePickerPopUp(
                              onCameraClick: (){
                                Navigator.pop(context);
                                pickImageFromCamera('Student');
                              },
                              onGalleryClick: (){
                                Navigator.pop(context);
                                pickImageFromGallery('Student');
                              },
                            );
                          },
                        );
                      },
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text('Blood Group', style: kSmallText()),
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
                              value: bloodValue != '' ? bloodValue : null,
                              hint: Text('Blood Group'),
                              items: bloodGroupList
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  bloodValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconMaterialButton(
                      iconData: Icons.file_upload_outlined,
                      title: labReportImage != null ? 'Change Lab Report' : 'Upload Lab Report',
                      onClick: (){
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context){
                            return ImagePickerPopUp(
                              onCameraClick: (){
                                Navigator.pop(context);
                                pickImageFromCamera('labReport');
                              },
                              onGalleryClick: (){
                                Navigator.pop(context);
                                pickImageFromGallery('labReport');
                              },
                            );
                          },
                        );
                      },
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text('Agent', style: kSmallText()),
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
                              value: agentValue != '' ? agentValue : null,
                              hint: Text('Agent'),
                              items: agentList
                                  .map<DropdownMenuItem<String>>((value) {
                                String middleName = value.middleName != '' ? '${value.middleName} ' : '';
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text('${value.firstName} $middleName${value.lastName}'),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  agentValue = newValue!;
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
                        Text('Religion', style: kSmallText()),
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
                              value: religionValue != '' ? religionValue : null,
                              hint: Text('Religion'),
                              items: religionList
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  religionValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    KTextField(
                      controller: email,
                      title: 'Email',
                      textInputType: TextInputType.emailAddress,
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text('Course', style: kSmallText()),
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
                              value: courseValue != '' ? courseValue : null,
                              hint: Text('Course'),
                              items: courseProvider.courseList
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.courseName),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  courseValue = newValue!;
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
                        Text('Semester', style: kSmallText()),
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
                              value: semesterValue != '' ? semesterValue : null,
                              hint: Text('Semester'),
                              items: semesterProvider.semesterList
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.name),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  semesterValue = newValue!;
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
                        Text('Session', style: kSmallText()),
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
                              value: sessionValue != '' ? sessionValue : null,
                              hint: Text('Session'),
                              items: sessionProvider.sessionList
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.name),
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
                        Text('Cast', style: kSmallText()),
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
                              value: castValue != '' ? castValue : null,
                              hint: Text('Cast'),
                              items: castList
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.name),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  castValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    KTextField(title: 'Current Address', controller: currentAddress,),
                    KTextField(title: 'Permanent Address', controller: permanentAddress,),
                    IconMaterialButton(
                      iconData: Icons.file_upload_outlined,
                      title: aadhaarCard != null ? 'Change Aadhaar Card' : 'Upload Aadhaar Card',
                      onClick: (){
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context){
                            return ImagePickerPopUp(
                              onCameraClick: (){
                                Navigator.pop(context);
                                pickImageFromCamera('aadhaarCard');
                              },
                              onGalleryClick: (){
                                Navigator.pop(context);
                                pickImageFromGallery('aadhaarCard');
                              },
                            );
                          },
                        );
                      },
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text('Select Franchise', style: kSmallText()),
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
                              value: franchiseValue != '' ? franchiseValue : null,
                              hint: Text('Select Franchise'),
                              items: franchiseList
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(value.name),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  franchiseValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    KTextField(
                      title: 'Roll No',
                      controller: rollNo,
                      validate: (value){
                        return null;
                      },
                    ),
                    KTextField(
                      title: 'Registration No',
                      controller: registrationNo,
                      validate: (value){
                        return null;
                      },
                    ),
                    Text('Upload registration certificate'),
                    IconMaterialButton(
                      iconData: Icons.file_upload_outlined,
                      title: registrationCertificate != null ? 'Change Registration Certificate' : 'Upload Registration Certificate',
                      onClick: (){
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context){
                            return ImagePickerPopUp(
                              onCameraClick: (){
                                Navigator.pop(context);
                                pickImageFromCamera('registration');
                              },
                              onGalleryClick: (){
                                Navigator.pop(context);
                                pickImageFromGallery('registration');
                              },
                            );
                          },
                        );
                      },
                    ),
                    Text('Caution Money Payment Details', style: kLargeStyle()),
                    KTextField(
                      readOnly: true,
                      title: 'Payment Date',
                      controller: paymentDate,
                      onClick: (){
                        _selectDate(context, 3);
                      },
                      suffixButton: Icon(Icons.calendar_month_outlined),
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10.0),
                        Text('Select Payment Mode', style: kSmallText()),
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
                              value: paymentModeValue != '' ? paymentModeValue : null,
                              hint: Text('Select Payment Mode'),
                              items: paymentMode
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  paymentModeValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    KTextField(title: 'Transaction Id', controller: transactionID,),
                    KTextField(
                      title: 'Caution Money Amount', controller: cautionMoney,
                      textInputType: TextInputType.number,
                      validate: (value){
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: containerDesign(context),
              child: Column(
                children: [
                  Text('Guardian Detail', style: kLargeStyle()),
                  KTextField(title: 'Father Name', controller: fatherName,),
                  KTextField(title: 'Father Phone',
                    controller: fatherPhone,
                    textLimit: 10,
                    textInputType: TextInputType.number,
                  ),
                  KTextField(title: 'Father Occupation', controller: fatherOccupation,),
                  IconMaterialButton(
                    iconData: Icons.file_upload_outlined,
                    title: fatherIncomeCertificateImage != null ?
                    "Change Father's Income Certificate" :  "Upload Father's Income Certificate",
                    onClick: (){
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context){
                          return ImagePickerPopUp(
                            onCameraClick: (){
                              Navigator.pop(context);
                              pickImageFromCamera('Father');
                            },
                            onGalleryClick: (){
                              Navigator.pop(context);
                              pickImageFromGallery('Father');
                            },
                          );
                        },
                      );
                    },
                  ),
                  KTextField(title: 'Mother Name', controller: motherName,),
                  KTextField(
                    textLimit: 10,
                    title: 'Mother Phone',
                    controller: motherPhone,
                    textInputType: TextInputType.number,
                  ),
                  KTextField(title: 'Mother Occupation', controller: motherOccupation,),
                  IconMaterialButton(
                    iconData: Icons.file_upload_outlined,
                    title: motherIncomeCertificateImage != null ?
                    'Change Mother Income Certificate' : 'Upload Mother Income Certificate',
                    onClick: (){
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context){
                          return ImagePickerPopUp(
                            onCameraClick: (){
                              Navigator.pop(context);
                              pickImageFromCamera('Mother');
                            },
                            onGalleryClick: (){
                              Navigator.pop(context);
                              pickImageFromGallery('Mother');
                            },
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 5.0),
                  KTextField(title: 'Guardian Name', controller: guardianName,),
                  KTextField(
                    textLimit: 10,
                    title: 'Guardian Phone',
                    controller: guardianPhone,
                    textInputType: TextInputType.number,
                  ),
                  KTextField(title: 'Guardian Email', controller: guardianEmail,),
                  KTextField(title: 'Guardian Relation', controller: guardianRelation,),
                  KTextField(title: 'Guardian Occupation', controller: guardianOccupation,),
                  KTextField(title: 'Guardian Address', controller: guardianAddress,),
                  SizedBox(height: 5.0),
                  KButton(
                    title: 'Save',
                    onClick: (){
                      if(_formKey.currentState!.validate()){
                        if(maritalValue == ''){
                          toastMessage(message: 'Select Marital Status', colors: kRedColor);
                        } else if (genderValue == ''){
                          toastMessage(message: 'Select Marital Status', colors: kRedColor);
                        } else if (bloodValue == ''){
                          toastMessage(message: 'Select Blood Group', colors: kRedColor);
                        } else if (religionValue == ''){
                          toastMessage(message: 'Select Religion', colors: kRedColor);
                        } else if (courseValue == ''){
                          toastMessage(message: 'Select Course', colors: kRedColor);
                        } else if (semesterValue == ''){
                          toastMessage(message: 'Select Semester', colors: kRedColor);
                        } else if (castValue == ''){
                          toastMessage(message: 'Select Cast', colors: kRedColor);
                        } else if (paymentModeValue == ''){
                          toastMessage(message: 'Select Payment Mode', colors: kRedColor);
                        } else {
                          saveStudent(context);
                        }
                      } else {
                        toastMessage(message: 'Enter Required Fields', colors: kRedColor);
                      }
                    },
                  ),
                ],
              ),
            ),
            // SizedBox(height: 10.0),

          ],
        ),
      ),
    );
  }

  Future<String> saveStudent(context) async {

    Map<String, String> formData = {
      // 'id': null,
      'identification_no': studentID.text,
      'roll_no': rollNo.text,
      'registration_no': registrationNo.text,
      'first_name': firstName.text,
      'middle_name': middleName.text,
      'last_name': lastName.text,
      'gender': genderValue,
      'dob': dob.text,
      'admission_date': admissionDate.text,
      'mobile_no': mobile.text,
      'emergency_phone_number': emgMobile.text,
      'material_status': maritalValue,
      'admission_status': '1',
      'current_address': currentAddress.text,
      'permanent_address': permanentAddress.text,
      'religion': religionValue,
      'blood_group': bloodValue,
      'category_id': castValue,
      'email': email.text,
      'course_id': courseValue,
      'semester_id': semesterValue,
      'agent_id': agentValue,
      'father_name': fatherName.text,
      'father_phone': fatherPhone.text,
      'father_occupation': fatherOccupation.text,
      'mother_name': motherName.text,
      'mother_phone': motherPhone.text,
      'mother_occupation': motherOccupation.text,
      'guardian_name': guardianName.text,
      'guardian_phone': guardianPhone.text,
      'guardian_email': guardianEmail.text,
      'guardian_relation': guardianRelation.text,
      'guardian_occupation': guardianOccupation.text,
      'guardian_address': guardianAddress.text,
      'franchise_id': franchiseValue,
      'session_id': sessionValue,
      'payment_date': paymentDate.text,
      'mode_of_payment': paymentModeValue,
      'transaction_id': transactionID.text,
      'caution_money': cautionMoney.text,
      // 'image': (binary), //done
      // 'dob_proof': undefined, // done
      // 'blood_group_proof': (binary), //LAB REPORT //done
      // 'aadhaar_card_proof': undefined, //done
      // 'admission_slip': (binary), //done
      // 'father_income_proof': undefined, //done
      // 'mother_income_proof': undefined, //done
      // 'registration_proof': (binary), //done
    };
    String url = APIData.saveStudent;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(APIData.kHeader);
    request.fields.addAll(formData);

    if(dobCertificateImage != null){
      request.files.add(await http.MultipartFile.fromPath('dob_proof', dobCertificateImage!.path));
    }

    if(admissionSlip != null){
      request.files.add(await http.MultipartFile.fromPath('admission_slip', admissionSlip!.path));
    }

    if(studentImage != null){
      request.files.add(await http.MultipartFile.fromPath('image', studentImage!.path));
    }

    if(labReportImage != null){
      request.files.add(await http.MultipartFile.fromPath('blood_group_proof', labReportImage!.path));
    }

    if(aadhaarCard != null){
      request.files.add(await http.MultipartFile.fromPath('aadhaar_card_proof', aadhaarCard!.path));
    }

    if(registrationCertificate != null){
      request.files.add(await http.MultipartFile.fromPath('registration_proof', registrationCertificate!.path));
    }

    if(fatherIncomeCertificateImage != null){
      request.files.add(await http.MultipartFile.fromPath('father_income_proof', fatherIncomeCertificateImage!.path));
    }

    if(motherIncomeCertificateImage != null){
      request.files.add(await http.MultipartFile.fromPath('mother_income_proof', motherIncomeCertificateImage!.path));
    }

    var response = await request.send();
    var responseString = await response.stream.bytesToString();

    if(response.statusCode == 200){
      Navigator.pop(context);
      toastMessage(message: 'Student Admission Done');
    } else {
      print(responseString);
      setState(() {
        // isLoading = false;
      });
    }

    return 'Success';
  }
}
