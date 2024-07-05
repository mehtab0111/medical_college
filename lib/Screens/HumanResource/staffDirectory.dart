import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/localDatabase.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Screens/HumanResource/addStaff.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';

class StaffDirectory extends StatefulWidget {
  const StaffDirectory({super.key});

  @override
  State<StaffDirectory> createState() => _StaffDirectoryState();
}

class _StaffDirectoryState extends State<StaffDirectory> {

  String courseValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Staff Directory'),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddStaff()));
            },
            child: Text('+ Add Staff'),
          ),
          SizedBox(width: 10.0),
        ],
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
                  Text('  Select Criteria', style: kHeaderStyle()),
                  SizedBox(height: 5.0),
                  Text('  Role', style: kBoldStyle()),
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
                            hint: Text('Select Role'),
                            items: roleList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
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
                  SizedBox(height: 5.0),
                  Center(
                    child: KButton(
                      title: 'Search',
                      onClick: (){},
                    ),
                  ),
                  SizedBox(height: 5.0),
                  KTextField(title: 'Search By Keyword'),
                  SizedBox(height: 5.0),
                  Center(
                    child: KButton(
                      title: 'Search',
                      onClick: (){},
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: containerDesign(context),
              child: Column(
                children: [
                  Text('Staff List', style: kHeaderStyle()),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: SearchTextField(),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: studentList.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: roundedContainerDesign(context).copyWith(
                            boxShadow: boxShadowDesign(),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 35,
                              ),
                              SizedBox(width: 10.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Name', style: kBoldStyle()),
                                  Text('DEHS5519'),
                                  Text('Super Admin'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
