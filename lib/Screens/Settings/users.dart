import 'package:medical_college/Screens/Settings/staffListPage.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:medical_college/provider/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> with TickerProviderStateMixin {

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(child: Text('Student')),
            Tab(child: Text('Staff')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: containerDesign(context),
                  child: Column(
                    children: [
                      Text('Student List', style: kHeaderStyle()),
                      kSpace(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: studentProvider.studentList.length,
                        itemBuilder: (context, index){
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: roundedContainerDesign(context).copyWith(
                                boxShadow: boxShadowDesign(),
                              ),
                              child: Column(
                                children: [
                                  kRowText('User ID: ', studentProvider.studentList[index].id.toString()),
                                  kRowText('Student Name: ', studentProvider.studentList[index].firstName),
                                  kRowText('Course: ', studentProvider.studentList[index].courseName),
                                  kRowText('Fathers Name: ', studentProvider.studentList[index].fatherName),
                                  kRowText('Mobile Number: ', studentProvider.studentList[index].mobileNo),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          StaffListPage(),
        ],
      ),
    );
  }
}
