import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_house/commons/const.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_house/authentication.dart';
import 'package:provider/provider.dart';
//import 'package:projectname/userprofile2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'commons/utils.dart';
import 'controllers/FBCloudMessaging.dart';
import 'threadMain.dart';
import 'package:pet_house/loginScreen.dart';
import 'package:pet_house/tasks.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:firebase_user_stream/firebase_user_stream.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String initialRoute;
  MyApp({this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MaterialApp(
        title: 'Facebook Login',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LoginScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController _tabController;
  MyProfileData myData;

  bool _isLoading = false;

  @override
  void initState() {
    FBCloudMessaging.instance.takeFCMTokenWhenAppLaunch();
    FBCloudMessaging.instance.initLocalNotification();
    _tabController = new TabController(vsync: this, length: 5);
    _tabController.addListener(_handleTabSelection);
    _takeMyData();
    super.initState();
  }

  Future<void> _takeMyData() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myThumbnail;
    String myName;
    if (prefs.get('myThumbnail') == null) {
      String tempThumbnail = iconImageList[Random().nextInt(50)];
      prefs.setString('myThumbnail', tempThumbnail);
      myThumbnail = tempThumbnail;
    } else {
      myThumbnail = prefs.get('myThumbnail');
    }

    if (prefs.get('myName') == null) {
      String tempName = Utils.getRandomString(8);
      prefs.setString('myName', tempName);
      myName = tempName;
    } else {
      myName = prefs.get('myName');
    }
    myName = "khaled";

    final Firestore database = Firestore.instance;
    Future<DocumentSnapshot> snapshot =
        database.collection('Profile').document(uid).get();
    print("msmsmsmsmsmmsmsms $myName");
    setState(() {
      myData = MyProfileData(
        myThumbnail: myThumbnail,
        myName: myName,
        myLikeList: prefs.getStringList('likeList'),
        myLikeCommnetList: prefs.getStringList('likeCommnetList'),
        myFCMToken: prefs.getString('FCMToken'),
      );

      snapshot.then((DocumentSnapshot userSnapshot) => {
            /* insert here the code of what you want to do with the snapshot*/
          });
    });

    setState(() {
      _isLoading = false;
    });
  }

  void _handleTabSelection() => setState(() {});

  void onTabTapped(int index) {
    setState(() {
      _tabController.index = index;
    });
  }

  void updateMyData(MyProfileData newMyData) {
    setState(() {
      myData = newMyData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Argot'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () => signOutUser().then((value) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false);
            }),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          TabBarView(controller: _tabController, children: [
            ThreadMain(
              myData: myData,
              updateMyData: updateMyData,
            ),
            Your(
              //uid: null,
              myData: myData,
              updateMyData: updateMyData,
            ),
            // Profile(
            //   myData: myData,
            //   updateMyData: updateMyData,
            // ),
            // UserProfile(
            //   myData: myData,
            //   updateMyDataToMain: updateMyData,
            //   userData: userData,
            // ),
          ]),
          Utils.loadingCircle(_isLoading),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _tabController.index,
        selectedItemColor: Colors.amber[900],
        unselectedItemColor: Colors.grey[800],
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.people),
            title: new Text('Dashboard'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.people),
            title: new Text('Poems'),
          ),
        ],
      ),
    );
  }
}

Future<String> inputData() async {
  final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  print(user);
  final String uid = user.uid.toString();
  return uid;
}
