import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Theme/colors.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';

class GeneratePayroll extends StatefulWidget {
  const GeneratePayroll({super.key});

  @override
  State<GeneratePayroll> createState() => _GeneratePayrollState();
}

class _GeneratePayrollState extends State<GeneratePayroll> {

  int earningListLength = 1;
  int deductionListLength = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Payroll'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              decoration: containerDesign(context),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Generate Payroll', style: kLargeStyle()),
                  ),
                  KTextField(title: 'First Name'),
                  KTextField(title: 'Middle Name'),
                  KTextField(title: 'Last Name'),
                  KTextField(title: 'Department Name'),
                  KTextField(title: 'Designation Name'),
                  KTextField(title: 'Total days'),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: containerDesign(context),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Earning', style: kHeaderStyle()),
                      TextButton(
                        onPressed: (){
                          setState(() {
                            earningListLength++;
                          });
                        },
                        child: Text('+Add'),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: roundedShadedDesign(context),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: earningListLength,
                      itemBuilder: (context, index){
                        return Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Type',
                                ),
                              ),
                            ),
                            SizedBox(width: 5.0),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                textAlign: TextAlign.end,
                                decoration: InputDecoration(
                                  hintText: '0',
                                ),
                              ),
                            ),
                            if(index > 0)
                            IconButton(
                              onPressed: (){
                                setState(() {
                                  earningListLength--;
                                });
                              },
                              icon: Icon(Icons.close),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Deduction', style: kHeaderStyle()),
                      TextButton(
                        onPressed: (){
                          setState(() {
                            deductionListLength++;
                          });
                        },
                        child: Text('+Add'),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: roundedShadedDesign(context),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: deductionListLength,
                      itemBuilder: (context, index){
                        return Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Type',
                                ),
                              ),
                            ),
                            SizedBox(width: 5.0),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                textAlign: TextAlign.end,
                                decoration: InputDecoration(
                                  hintText: '0',
                                ),
                              ),
                            ),
                            if(index > 0)
                              IconButton(
                                onPressed: (){
                                  setState(() {
                                    deductionListLength--;
                                  });
                                },
                                icon: Icon(Icons.close),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  kSpace(),
                  KButton(
                    title: 'Save',
                    onClick: (){},
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
