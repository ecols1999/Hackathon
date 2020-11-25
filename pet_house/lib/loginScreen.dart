import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_house/authentication.dart';
import 'package:pet_house/forgot_pasword.dart';
import 'package:pet_house/localization/l10n/language.dart';
import 'package:pet_house/localization/l10n/language_constants.dart';
import 'package:pet_house/main.dart';
import 'package:pet_house/signupScreen.dart';
import 'package:form_field_validator/form_field_validator.dart';
//import 'package:pet_house/threadMain.dart';
//import 'package:pet_house/tasks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'blocks/auth_bloc.dart';
import 'main.dart';
import 'tasks.dart';
import 'dart:async';
import 'package:pet_house/blocks/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  StreamSubscription<FirebaseUser> loginStateSubscription;

  String email;
  String password;

  // add localization
  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MyHomePage()));
      }
    });
    super.initState();
  }

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void login() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      signin(email, password, context).then((value) {
        if (value != null) {
          inputData1();
          profileSet();
          //add user to database so that errors don't result
          Firestore.instance
              .collection('User-Database')
              .document(uid)
              .setData({'key': 1});
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(),
              ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          // drop menue to select lang
          DropdownButton<Language>(
            underline: SizedBox(),
            icon: Icon(
              Icons.language,
              color: Colors.white,
            ),
            onChanged: (Language language) {
              _changeLanguage(language);
            },
            items: Language.languageList()
                .map<DropdownMenuItem<Language>>(
                  (e) => DropdownMenuItem<Language>(
                    value: e,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          e.flag,
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(e.name)
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
        title: Text(getTranslated(context, 'title')),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(
                    Radius.circular(20.0)), //add border radius here
                child: Container(
                  height: 250.0,
                  width: 250.0,
                  child: Image.asset(
                    'images/logo/logo.jpeg',
                    
                  ), //add image location here
                ),
              ),
              
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      
                  
                      
                      
                    ],
                  ),
                ),
              ),
              SignInButton(
                Buttons.Google,
                onPressed: () => googleSignIn().whenComplete(() async {
                  FirebaseUser user = await FirebaseAuth.instance.currentUser();
                  //print('The user ID is');
                  //print(user.uid); //testing to see what's passed

                  inputData1(); //this gets the user id

                  if (user != null) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  }
                }),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
