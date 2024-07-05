import 'dart:async';
import 'dart:convert';
import 'package:medical_college/Components/DialougBox/deletePopUp.dart';
import 'package:medical_college/Components/util.dart';
import 'package:http/http.dart' as http;
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';

class SemesterPage extends StatefulWidget {
  const SemesterPage({super.key});

  @override
  State<SemesterPage> createState() => _SemesterPageState();
}

class _SemesterPageState extends State<SemesterPage> {

  final StreamController _streamController = StreamController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController semesterName = TextEditingController();

  String semesterID = '';
  bool updateData = false;

  @override
  void initState() {
    super.initState();
    getSemester();
  }

  Future<String> getSemester() async {
    String url = APIData.getSemester;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader);
    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      _streamController.add(jsonData['data']);
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  Future<String> saveSemester() async {
    String url = APIData.saveSemester;
    var response = await http.post(Uri.parse(url), headers: APIData.kHeader,
      body: jsonEncode({
        'name': semesterName.text,
      }),
    );
    if(response.statusCode == 200){
      getSemester();
      semesterName.clear();
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Semester'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: containerDesign(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text('Add Semester', style: kHeaderStyle()),
                  ),
                  Form(
                    key: _formKey,
                    child: KTextField(title: 'Enter Semester Name', controller: semesterName,),
                  ),
                  SizedBox(height: 5.0),
                  Center(
                    child: updateData != true ? KButton(
                      title: 'Save',
                      onClick: (){
                        if(_formKey.currentState!.validate()){
                          saveSemester();
                        }
                      },
                    ) : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: KButton(
                              title: 'Update',
                              onClick: (){
                                updateSemester();
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: KButton(
                              title: 'Cancel',
                              onClick: (){
                                setState(() {
                                  updateData = false;
                                  semesterName.clear();
                                });
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
            SizedBox(height: 10.0),
            StreamBuilder(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  var data = snapshot.data;
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    decoration: containerDesign(context),
                    child: Column(
                      children: [
                        Text('Semester Name', style: kHeaderStyle()),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Semester', style: kBoldStyle()),
                            Text('Action', style: kBoldStyle()),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index){
                            return Row(
                              children: [
                                Text(data[index]['name']),
                                Spacer(),
                                IconButton(
                                  onPressed: (){
                                    print('${data[index]['name']}');
                                    setState(() {
                                      semesterID = '${data[index]['id']}';
                                      semesterName.text = '${data[index]['name']}';
                                      updateData = true;
                                    });
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: (){
                                    deletePopUp(context, onClickYes: (){
                                      deleteSemester(data[index]['id'].toString());
                                      Navigator.pop(context);
                                    });
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
                return LoadingIcon();
              }
            )
          ],
        ),
      ),
    );
  }

  Future<String> updateSemester() async {
    String url = APIData.updateSemester;
    var response = await http.post(Uri.parse(url), headers: APIData.kHeader,
      body: jsonEncode({
        "id": semesterID,
        "name": semesterName.text
      }),
    );
    if(response.statusCode == 200){
      setState(() {
        updateData = false;
        semesterName.clear();
      });
      toastMessage(message: 'Semester Updated');
      getSemester();
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  Future<String> deleteSemester(String semesterID) async {
    String url = APIData.deleteSemester;
    var response = await http.get(Uri.parse('$url/$semesterID'),
        headers: APIData.kHeader);
    if(response.statusCode == 200){
      toastMessage(message: 'Semester deleted');
      getSemester();
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }
}

// showModalBottomSheet(
//   context: context,
//   builder: (context) {
//     return StatefulBuilder(
//       builder: (BuildContext context, StateSetter setState) {
//         return Container(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             // mainAxisSize: MainAxisSize.min,
//             children: [
//               KTextField(
//                 title: 'Semester Name',
//                 controller: updateSemesterName,
//               ),
//               KButton(title: 'Save', onClick: (){
//                 updateSemester(data[index]['id'].toString());
//                 Navigator.pop(context);
//               }),
//             ],
//           ),
//         );
//       },
//     );
//   },
// );
