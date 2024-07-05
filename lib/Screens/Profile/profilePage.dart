import 'package:medical_college/Screens/Profile/editProfile.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
            },
            child: Text('Edit'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: roundedContainerDesign(context),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 57,
                      backgroundColor: kMainColor,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: AssetImage('images/img_blank_profile.png'),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text('Pikash Pratim Maity', style: kHeaderStyle()),
                    SizedBox(height: 20.0),
                    kRowText('Staff ID: ', 'DITS001'),
                    kRowText('Roll: ', 'Admin'),
                    kRowText('Designation: ', 'Principal'),
                    kRowText('Department: ', 'ASSISTANT PROFESSOR'),
                    kRowText('EPF NO: ', ''),
                    kRowText('Basic Salary: ', ''),
                    kRowText('Contact Type: ', ''),
                    kRowText('Work Shift: ', ''),
                    kRowText('Location: ', ''),
                    kRowText('Date of joining: ', '04/12/2007'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: roundedContainerDesign(context),
                child: Column(
                  children: [
                    k2RowText(
                      iconData: Icons.phone,
                      title: 'Phone',
                      desc: '',
                    ),
                    k2RowText(
                      iconData: Icons.phone,
                      title: 'EMG Contact Number',
                      desc: '',
                    ),
                    k2RowText(
                      iconData: Icons.email_outlined,
                      title: 'Email',
                      desc: 'librarian@email.com',
                    ),
                    k2RowText(
                      iconData: Icons.transgender_outlined,
                      title: 'Gender',
                      desc: 'Male',
                    ),
                    k2RowText(
                      iconData: Icons.calendar_month_outlined,
                      title: 'Date of birth',
                      desc: '01/01/2022',
                    ),
                    k2RowText(
                      iconData: Icons.phone,
                      title: 'Marital Status',
                      desc: '',
                    ),
                    k2RowText(
                      iconData: Icons.person_outlined,
                      title: 'Father Name',
                      desc: '',
                    ),
                    k2RowText(
                      iconData: Icons.person_outlined,
                      title: 'Mother Name',
                      desc: '',
                    ),
                    k2RowText(
                      iconData: Icons.school_outlined,
                      title: 'Qualification',
                      desc: '',
                    ),
                    k2RowText(
                      iconData: Icons.circle,
                      title: 'Work Experience',
                      desc: '',
                    ),
                    k2RowText(
                      iconData: Icons.note_alt_outlined,
                      title: 'Note',
                      desc: '',
                    ),
                    k2RowText(
                      iconData: Icons.bookmark_outlined,
                      title: 'Adhaar Number',
                      desc: '',
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: k3Color,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Icon(Icons.location_on_outlined, color: kWhiteColor),
                            SizedBox(width: 5.0),
                            Text('Address', style: kHeaderStyle().copyWith(
                              color: kWhiteColor,
                            )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    k2RowText(
                      title: 'Current Address',
                      desc: '',
                    ),
                    k2RowText(
                      title: 'Permanent Address',
                      desc: '',
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: k3Color,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Icon(Icons.account_balance_outlined, color: kWhiteColor),
                            SizedBox(width: 5.0),
                            Text('Bank Account Details', style: kHeaderStyle().copyWith(
                              color: kWhiteColor,
                            )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    k2RowText(
                      title: 'Account Title',
                      desc: '',
                    ),
                    k2RowText(
                      title: 'Bank Name',
                      desc: '',
                    ),
                    k2RowText(
                      title: 'Bank Branch Name',
                      desc: '',
                    ),
                    k2RowText(
                      title: 'Bank Account Number',
                      desc: '',
                    ),
                    k2RowText(
                      title: 'IFSC Code',
                      desc: '',
                    ),
                  ],
                ),
              ),
            ),
            kSpace(),
          ],
        ),
      ),
    );
  }
}

Widget k2RowText({IconData? iconData, required String title, required String desc}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(iconData != null)
        Icon(iconData),
        if(iconData != null)
        SizedBox(width: 10.0),
        Text(title),
        SizedBox(width: 10.0),
        Expanded(child: Text(desc, textAlign: TextAlign.right),),
      ],
    ),
  );
}
