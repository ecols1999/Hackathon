import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Bio:",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
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
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Education",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: controller,
                //obscureText: true,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Education',
                  isDense: true, // Added this
                  //contentPadding: EdgeInsets.all(30),
                ),
                style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Hobbies",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: controller,
                //obscureText: true,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'hobbies',
                  isDense: true, // Added this
                  //contentPadding: EdgeInsets.all(30),
                ),
                style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Info2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.00,
      child: RaisedButton(
          onPressed: () {},
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          elevation: 0.0,
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Colors.redAccent, Colors.pinkAccent]),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Container(
              constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
              alignment: Alignment.center,
              child: Text(
                "Contact me",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.0,
                    fontWeight: FontWeight.w300),
              ),
            ),
          )),
    );
  }
}
