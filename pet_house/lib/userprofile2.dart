import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_house/Khaled/database.dart';
import 'package:pet_house/editProfile.dart';
//import 'package:pet_house/Khaled/list.dart';
import 'package:pet_house/Khaled/user.dart';
import 'package:pet_house/tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'commons/const.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';

class UserProfile extends StatefulWidget {
  //final DocumentSnapshot data;
  final MyProfileData myData;
  final UserData userData;

  final ValueChanged<MyProfileData> updateMyDataToMain;
  UserProfile({this.myData, this.updateMyDataToMain, this.userData});
  @override
  State<StatefulWidget> createState() => _UserProfile();
}

UserData userData; //maybe this global variable will work

class _UserProfile extends State<UserProfile> {
  String name = 'Shakespeare William';
  int viewType;
  String _myThumbnail;
  String _myName;
  //String _myAge;

  //UserData userData;

  String _userImage;
  String _userPhoneNumber;
  String _userAge;
  String _userName;

  //String name;
  // DocumentSnapshot data;

  MyProfileData myData;

  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _updateUserData().then((dataStuff) {
      _userImage = userData.profileImage;
      _userName = userData.name;
      _userPhoneNumber = userData.phoneNumber;
      _userAge = userData.age;
      _myName = userData.name; //was different
      //_myThumbnail = widget.myData.myThumbnail;
      //_myThumbnail = widget.userData.profileImage;
      //_myAge = userData.age;
      // _myName = widget.userData.name;
    });
  }

  Future<void> _updateUserData() async {
    setState(() {
      final Firestore database = Firestore.instance;
      Future<DocumentSnapshot> snapshot =
          database.collection('Profile').document(uid).get();
      // DatabaseService(uid: uid).updateUserData(name, age, phoneNumber);

      snapshot.then((DocumentSnapshot userSnapshot) async {
        //was in arrow notation
        userData.profileImage =
            await userSnapshot['profileImage']; //awaits used to not be here
        userData.phoneNumber = await userSnapshot['PhoneNumber'];
        userData.age = await userSnapshot['age'];
        userData.name = await userSnapshot['name'];
      });
    });
  }

  void updateMyData(MyProfileData newMyData) {
    setState(() {
      myData = newMyData;
    });
  }

  Future uploadPic(BuildContext context) async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    //StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

    //StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    setState(() {
      print("Profile Picture uploaded");
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });

    var url = await firebaseStorageRef.getDownloadURL();
    print("this is url: $url");

    _myThumbnail = url;
    _myName = userData.name;
    //_myThumbnail = widget.myData.myThumbnail;
    //_showDialog2()

    // _updateMyData(widget.myData.myName, _myThumbnail, _myAge);

    DatabaseService(uid: uid).updateUserData(
        _userName, int.parse(_userAge), int.parse(_userPhoneNumber), url);
    _updateUserData();
    _updateMyData(_myName, _myThumbnail);

    print("this is $_myThumbnail");
  }

  //final size = MediaQuery.of(context).size;

  Future getImage(BuildContext context) async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
      // _myThumbnail = "$_image";
    });

    //uploadPic(context);
    uploadPic2(context);
  }

  Future uploadPic2(BuildContext context) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference reference = storage.ref().child("profilePics/$uid");
    StorageUploadTask uploadTask = reference.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String url = await taskSnapshot.ref.getDownloadURL();

    Firestore.instance
        .collection('Profile')
        .document(uid)
        .updateData({'profileImage': url});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder(
                stream: Firestore.instance
                    .collection('Profile')
                    .document(uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LinearProgressIndicator();

                  return Container(
                    /*decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.lightBlue, Colors.black])),*/
                    child: Container(
                      width: double.infinity,
                      //height: 230.0,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.center,
                                          child: CircleAvatar(
                                            radius: 100,
                                            backgroundColor: Color(0xff476cfb),
                                            child: ClipOval(
                                              child: new SizedBox(
                                                width: 180.0,
                                                height: 180.0,
                                                child: (_image != null)
                                                    ? Image.file(
                                                        _image,
                                                        fit: BoxFit.fill,
                                                      )
                                                    : Image.network(
                                                        //'$_userImage',
                                                        '${snapshot.data['profileImage']}',
                                                        fit: BoxFit.fill,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 60.0),
                                          child: IconButton(
                                            icon: Icon(Icons.photo_camera,
                                                size: 40.0, color: Colors.blue),
                                            onPressed: () {
                                              getImage(context);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {},
                            ),
                            SizedBox(
                              height: 5.0,
                            ),

                            Text('Profile Information',
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold)),

                            SizedBox(
                                height: 20), //to add space between text widgets

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //this is the name card

                                Card(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 5.0),
                                  clipBehavior: Clip.antiAlias,
                                  color: Colors.white,
                                  elevation: 5.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 5.0),
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                            child: Text(
                                          'Username: ${snapshot.data['name']}',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left,
                                        ))
                                      ],
                                    ),
                                  ),
                                ),

                                //this is the phonenumber card
                                Card(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 5.0),
                                  clipBehavior: Clip.antiAlias,
                                  color: Colors.white,
                                  elevation: 5.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 5.0),
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                            child: Text(
                                                'Phone Number: ${snapshot.data['PhoneNumber']}',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold)))
                                      ],
                                    ),
                                  ),
                                ),

                                Card(
                                  //this is the age card
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 5.0),
                                  clipBehavior: Clip.antiAlias,
                                  color: Colors.white,
                                  elevation: 5.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 5.0),
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                            child: Text(
                                          'Age: ${snapshot.data['age']}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),

                                Card(
                                  //this is the email card
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 5.0),
                                  clipBehavior: Clip.antiAlias,
                                  color: Colors.white,
                                  elevation: 5.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 5.0),
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                            child: Text('Email: ${emailEmail}',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold)))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Edit(snapData: snapshot.data)));
                                  },
                                  child: Text('Edit Field',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold)),
                                  textColor: Colors.white,
                                  color: Colors.blue,
                                  //minWidth: 50,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Future<void> _updateMyData(String newName, String newThumbnail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('myName', newName);
    prefs.setString('myThumbnail', newThumbnail);
    //  prefs.setString('myAge', newAge);

    setState(() {
      _myThumbnail = newThumbnail;
      _myName = newName;
      // _myAge = newAge;
    });
    MyProfileData newMyData =
        MyProfileData(myName: newName, myThumbnail: newThumbnail);
    widget.updateMyDataToMain(newMyData);
  }
}
