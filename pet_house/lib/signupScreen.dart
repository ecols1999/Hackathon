import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_house/authentication.dart';
import 'package:pet_house/loginScreen.dart';
//import 'package:pet_house/tasks.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pet_house/tasks.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String email;
  String password;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  void handleSignup() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      signUp(email.trim(), password, context).then((value) {
        if (value != null) {
          inputData1();
          //add user to database so that errors don't result
          Firestore.instance
              .collection('User-Database')
              .document(uid)
              .setData({'key': 1});

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(), //simple fix
              ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(
                    Radius.circular(20.0)), //add border radius here
                child: Container(
                  height: 150.0,
                  width: 150.0,
                  child: Image.asset(
                    'images/logo/logo.png',
                  ), //add image location here
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Signup Here",
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "Email"),
                        validator: (_val) {
                          if (_val.isEmpty) {
                            return "Can't be empty";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {
                          email = val;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Password"),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "This Field Is Required."),
                            MinLengthValidator(6,
                                errorText: "Minimum 6 Characters Required.")
                          ]),
                          controller: _pass,
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Confirm Password"),
                          validator: (val) => MatchValidator(
                                  errorText: 'Passwords do not match')
                              .validateMatch(val, password),
                        ),
                      ),
                      RaisedButton(
                        onPressed: handleSignup,
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Text(
                          "Sign Up",
                        ),
                      ),
                      SignInButton(
                        Buttons.Google,
                        onPressed: () => googleSignIn().whenComplete(() async {
                          FirebaseUser user =
                              await FirebaseAuth.instance.currentUser();
                          //print('The user ID is');
                          //print(user.uid); //testing to see what's passed

                          inputData1(); //this gets the user id

                          if (user != null) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()));
                          }
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              InkWell(
                onTap: () {
                  // send to login screen
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  "Login Here",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
