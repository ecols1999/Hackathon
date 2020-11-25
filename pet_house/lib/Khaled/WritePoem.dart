import 'package:flutter/material.dart';
import 'package:pet_house/Khaled/ProfileBody.dart';
import 'Profile.dart';

class WritePoem extends StatelessWidget {
  BodyLayoutState obj = new BodyLayoutState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("peome Page"),
      ),
      body: BodyLayout(),
      //Center(
      //   child: RaisedButton(
      //     onPressed: () {
      //       //obj.insertItem();
      //     },
      //     child: Text('Post Poem'),
      //   ),
      // ),
    );
  }
}
