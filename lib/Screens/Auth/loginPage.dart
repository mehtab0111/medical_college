import 'dart:convert';
import 'package:medical_college/Components/buttons.dart';
import 'package:medical_college/Components/textField.dart';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Screens/navigationScreen.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Services/serviceManager.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool textObscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/back3.jpg'),
          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.4), BlendMode.srcATop),
          fit: BoxFit.cover,
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RotationTransition(
                turns: AlwaysStoppedAnimation(-5 / 360),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: blurCurveDecor(context),
                  child: RotationTransition(
                    turns: AlwaysStoppedAnimation(5 / 360),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          kSpace(),
                          Image.asset('images/noBGLogo.jpg'),
                          SizedBox(height: 20.0),
                          Text('Login', style: kHeaderStyle()),
                          KTextField(title: 'User ID', controller: email,),
                          KTextField(
                            title: 'Password',
                            controller: password,
                            obscureText: textObscure,
                            suffixButton: IconButton(
                              onPressed: (){
                                setState(() {
                                  textObscure = !textObscure;
                                });
                              },
                              icon: Icon(textObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            ),
                          ),
                          kSpace(),
                          KButton(
                            title: 'Submit',
                            onClick: (){
                              if(_formKey.currentState!.validate()){

                                userLogin(context);

                                // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                //     // builder: (context) => NavigationController()), (route) => false);
                                //     builder: (context) => NavigationScreen()), (route) => false);
                              }
                            },
                          ),
                          kSpace(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> userLogin(context) async {
    String url = APIData.login;
    var res = await http.post(Uri.parse(url), body: jsonEncode({
      'email': email.text,
      'password': password.text,
    }));
    if(res.statusCode == 200) {
      var data = jsonDecode(res.body);

      ServiceManager().setUser('${data['data']['id']}');
      ServiceManager().setToken('${data['data']['token']}');
      ServiceManager().getUserID();
      ServiceManager().getTokenID();

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) => NavigationScreen()), (route) => false);
      toastMessage(message: 'Logged In');

    } else {
      toastMessage(message: 'Invalid Email and Password');
      print(res.statusCode);
      print(res.body);
    }
    return 'Success';
  }
}
