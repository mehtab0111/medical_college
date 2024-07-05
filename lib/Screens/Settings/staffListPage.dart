import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/provider/members_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class StaffListPage extends StatefulWidget {
  const StaffListPage({super.key});

  @override
  State<StaffListPage> createState() => _StaffListPageState();
}

class _StaffListPageState extends State<StaffListPage> {

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MembersProvider>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: containerDesign(context),
            child: Column(
              children: [
                Text('Staff List', style: kHeaderStyle()),
                kSpace(),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: memberProvider.memberList.length,
                  itemBuilder: (context, index){
                    return Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                      decoration: roundedContainerDesign(context).copyWith(
                        boxShadow: boxShadowDesign(),
                      ),
                      child: Column(
                        children: [
                          kRowText('Staff ID: ', memberProvider.memberList[index].id.toString()),
                          kRowText('Name: ', memberProvider.memberList[index].firstName),
                          kRowText('Email: ', memberProvider.memberList[index].email),
                          // kRowText('Role: ', memberProvider.memberList[index].role),
                          kRowText('Designation: ', memberProvider.memberList[index].designationName),
                          kRowText('Department: ', memberProvider.memberList[index].departmentName),
                          kRowText('Phone: ', memberProvider.memberList[index].mobileNo.toString()),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return kSpace();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
