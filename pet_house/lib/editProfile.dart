/// Flutter code sample for Radio

// Here is an example of Radio widgets wrapped in ListTiles, which is similar
// to what you could get with the RadioListTile widget.
//
// The currently selected character is passed into `groupValue`, which is
// maintained by the example's `State`. In this case, the first `Radio`
// will start off selected because `_character` is initialized to
// `SingingCharacter.lafayette`.
//
// If the second radio button is pressed, the example's state is updated
// with `setState`, updating `_character` to `SingingCharacter.jefferson`.
// This causes the buttons to rebuild with the updated `groupValue`, and
// therefore the selection of the second button.
//
// Requires one of its ancestors to be a [Material] widget.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_house/tasks.dart';

enum SingingCharacter { username, phone, age }

class Edit extends StatefulWidget {
  final snapData;
  Edit({Key key, this.snapData}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _Edit();
}

class _Edit extends State<Edit> {
  SingingCharacter _character = SingingCharacter.username;
  TextEditingController writingTextController = TextEditingController();
  FocusNode writingTextFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Change the Desired Field'),
          centerTitle: true,
          actions: <Widget>[
            /*FlatButton(
                onPressed: () {},
                child: Text(
                  'Post',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ))*/
          ],
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            ListTile(
              title: const Text(
                'Username',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              leading: Radio(
                value: SingingCharacter.username,
                groupValue: _character,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text(
                'Phone Number',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              leading: Radio(
                value: SingingCharacter.phone,
                groupValue: _character,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text(
                'Age',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              leading: Radio(
                value: SingingCharacter.age,
                groupValue: _character,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            TextFormField(
              autofocus: true,
              focusNode: writingTextFocus,
              decoration: InputDecoration(
                //border: InputBorder.none,
                hintText: 'Enter a new field',
                hintMaxLines: 4,
              ),
              controller: writingTextController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    //widget.snapData

                    print('The value is ${_character.toString()}');
                    _editInfo(context, widget.snapData, _character.toString(),
                        writingTextController.text);

                    //Navigator.pop(context);
                  },
                  child: Text('Confirm',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  textColor: Colors.white,
                  color: Colors.blue,
                  //minWidth: 50,
                )
              ],
            )
          ],
        ));
  }
}

Future<String> _editInfo(
    var context, var widget, String option, String newField) async {
  var option2 = option.toString();
  String field;
  if (option2 == "SingingCharacter.username") {
    field = "name";
    Firestore.instance
        .collection('Profile')
        .document(uid)
        .updateData({field: newField});
  } else if (option2 == "SingingCharacter.phone") {
    field = "PhoneNumber";
    Firestore.instance
        .collection('Profile')
        .document(uid)
        .updateData({field: newField});
  } else if (option2 == "SingingCharacter.age") {
    field = "age";
    Firestore.instance
        .collection('Profile')
        .document(uid)
        .updateData({field: newField});
  }
  //SingingCharacter.username
  Navigator.pop(context);
}
