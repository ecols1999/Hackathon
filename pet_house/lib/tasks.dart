import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_house/commons/const.dart';
import 'package:pet_house/contentDetail.dart';
import 'package:pet_house/subViews/threadItem2.dart';
import 'package:pet_house/writePost.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'commons/utils.dart';

class Your extends StatefulWidget {
  final MyProfileData myData;
  final ValueChanged<MyProfileData> updateMyData;
  Your({this.myData, this.updateMyData});
  @override
  State<StatefulWidget> createState() => _ThreadMain();
}

class _ThreadMain extends State<Your> {
  bool _isLoading = false;

  void _writePost() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WritePost(
                  myData: widget.myData,
                )));
  }

  @override
  Widget build(BuildContext context) {
    inputData1(); //maybe this can fix the error of having the wrong poems in the 'Your Poems' section
    profileSet();
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('thread')
              .where('userID', isEqualTo: uid)
              .orderBy('postTimeStamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            return Stack(
              children: <Widget>[
                snapshot.data.documents.length > 0
                    ? ListView(
                        shrinkWrap: true,
                        children: snapshot.data.documents
                            .map((DocumentSnapshot data) {
                          return ThreadItem(
                            data: data,
                            myData: widget.myData,
                            updateMyDataToMain: widget.updateMyData,
                            threadItemAction: _moveToContentDetail,
                            isFromThread: true,
                            commentCount: data['postCommentCount'],
                            viewCount: data['viewCount'],
                          );
                        }).toList(),
                      )
                    : Container(
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.error,
                              color: Colors.grey[700],
                              size: 64,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text(
                                'There is no post',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[700]),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )),
                      ),
                Utils.loadingCircle(_isLoading),
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _writePost,
        tooltip: 'Increment',
        child: Icon(Icons.create),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _moveToContentDetail(DocumentSnapshot data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContentDetail(
                  postData: data,
                  myData: widget.myData,
                  updateMyData: widget.updateMyData,
                )));
  }
}

String uid;
String emailName;
String emailEmail;

Future<Void> inputData1() async {
  final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //print(user);
  uid = user.uid.toString();
  emailName = user.displayName.toString();
  emailEmail = user.email.toString();
}

Future<Void> profileSet() async {
  await Firestore.instance
      .collection('Profile')
      .document(uid) //should be uid I think
      .get()
      .then((docSnapshot) async {
    if (!docSnapshot.exists) {
      await Firestore.instance //await used to not be here
          .collection('Profile')
          .document(uid) //should be uid I think
          .setData({
        'name': "name",
        'age': "age",
        'PhoneNumber': "phoneNumber",
        'profileImage': 'https://picsum.photos/250?image=9',
      });
    }
  });
}
