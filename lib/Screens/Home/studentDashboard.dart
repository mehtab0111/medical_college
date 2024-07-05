import 'package:medical_college/Components/localDatabase.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';

class StudentDashBoard extends StatefulWidget {
  const StudentDashBoard({super.key});

  @override
  State<StudentDashBoard> createState() => _StudentDashBoardState();
}

class _StudentDashBoardState extends State<StudentDashBoard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10.0),
                  decoration: roundedContainerDesign(context).copyWith(
                    color: k3Color,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 180),
                      Text('Welcome Student', style: kHeaderStyle().copyWith(
                        color: kWhiteColor,
                      )),
                      Text('Welcome back your dashboard is ready', style: kSmallText().copyWith(
                        color: kWhiteColor,
                      )),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: Image.asset('images/student.png', height: 200,),
              ),
            ],
          ),
        ),
        kSmallDesign(
          context,
          title: 'Student Material',
          desc: '80',
          image: 'images/download-pdf.png',
          sliderValue: 80
        ),
        kSmallDesign(
          context,
          title: 'Mock Test',
          desc: '40',
          image: 'images/test.png',
          sliderValue: 40
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Container(
            decoration: roundedContainerDesign(context),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10.0),
                    ),
                    color: k3Color,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Recent Classes', style: kHeaderStyle().copyWith(
                      color: kWhiteColor
                    )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Semester'),
                          Text('Subject'),
                        ],
                      ),
                      Divider(thickness: 1),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        itemBuilder: (context, index){
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('1st Semester'),
                              Text('CODE128'),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(thickness: 1);
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Container(
            decoration: roundedContainerDesign(context),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10.0),
                    ),
                    color: k3Color,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Weekly Attendance', style: kHeaderStyle().copyWith(
                        color: kWhiteColor
                    )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Day'),
                          Text('Status'),
                        ],
                      ),
                      Divider(thickness: 1),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: weekList.length,
                        itemBuilder: (context, index){
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(weekList[index]),
                              Icon(index != 0 ? Icons.check : Icons.close),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(thickness: 1);
                        },
                      )
                    ],
                  ),
                ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Notice Board', style: kHeaderStyle()),
                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.more_horiz_outlined),
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index){
                    return Row(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          child: Image.asset('images/board.png'),
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mock Test'),
                            Text('29 July, 2023'),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Padding kSmallDesign(BuildContext context, {
  required String title,
  required String desc,
  required String image,
  required double sliderValue,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
    child: Container(
      padding: EdgeInsets.all(10.0),
      decoration: roundedContainerDesign(context),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title),
                    Text(desc),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(image),
              ),
            ],
          ),
          Slider(
            value: sliderValue,
            max: 100,
            divisions: 100,
            label: 80.round().toString(),
            onChanged: (double value) {},
          ),
        ],
      ),
    ),
  );
}
