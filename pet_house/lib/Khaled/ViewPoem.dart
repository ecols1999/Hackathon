import 'package:flutter/material.dart';
import 'package:pet_house/Khaled/ProfileBody.dart';
import 'Profile.dart';

class ViewPoem extends StatelessWidget {
  BodyLayoutState obj = new BodyLayoutState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("View Poem"),
      ),
      body: ViewPoem1(),
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

class ViewPoem1 extends StatelessWidget {
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: controller,
        //obscureText: true,
        maxLines: null,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Bio',
          isDense: true, // Added this
          //contentPadding: EdgeInsets.all(30),
        ),
        style: TextStyle(
          fontSize: 22.0,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w300,
          color: Colors.black,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}
