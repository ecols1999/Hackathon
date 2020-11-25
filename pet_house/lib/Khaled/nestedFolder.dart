import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_house/Khaled/folder.dart';
import 'package:pet_house/Khaled/profile2.dart';
import 'package:pet_house/Khaled/user.dart';
import 'package:pet_house/commons/const.dart';
import 'package:pet_house/contentDetail.dart';
import 'package:pet_house/subViews/threadItem.dart';
import 'package:pet_house/writePost.dart';
//import 'main.dart';

import '../commons/utils.dart';
import '../tasks.dart';

class Folder extends StatefulWidget {
  final MyProfileData myData;
  final ValueChanged<MyProfileData> updateMyData;
  Folder({this.myData, this.updateMyData});
  @override
  State<StatefulWidget> createState() => _Folder();
}

class _Folder extends State<Folder> {
  bool _isLoading = false;
  String folderName;
  MyProfileData myData;
  UserData userData;

  void _writePost() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WritePost(
                  myData: widget.myData,
                )));
  }

  void _createFolder() async {
    TextEditingController _changeNameTextController = TextEditingController();
    await showDialog(
      context: this.context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Type the name of the folder',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    hintText: 'ex) loydkim',
                    icon: Icon(Icons.edit)),
                controller: _changeNameTextController,
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(this.context);
              }),
          new FlatButton(
              child: const Text('SAVE'),
              onPressed: () {
                folderName = _changeNameTextController.text;
                Firestore.instance
                    .collection('FolderName')
                    .document(uid)
                    .collection(uid)
                    .document(folderName)
                    .setData({"folderName": folderName});
                Navigator.pop(this.context);
              })
        ],
      ),
    );
  }

  // String type;
  // String dropdownValue = 'All';
  // TextEditingController search;
  // _searchBar() {
  //   return Container(
  //     height: 50,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         Expanded(
  //           flex: 3,
  //           child: TextFormField(
  //             //autofocus: true,
  //             decoration: InputDecoration(
  //               border: InputBorder.none,
  //               hintText: 'Search ...',
  //               hintMaxLines: 4,
  //             ),
  //             controller: search,
  //             keyboardType: TextInputType.multiline,
  //             maxLines: null,
  //           ),
  //         ),
  //         Expanded(
  //           flex: 1,
  //           child: DropdownButton<String>(
  //             value: dropdownValue,
  //             icon: Icon(Icons.arrow_downward),
  //             iconSize: 30,
  //             elevation: 16,
  //             style: TextStyle(color: Colors.blueAccent),
  //             underline: Container(
  //               height: 3,
  //               color: Colors.blueAccent,
  //             ),
  //             onChanged: (String newValue) {
  //               setState(() {
  //                 dropdownValue = newValue;
  //                 type = newValue;
  //                 if (type == 'All') type = null;
  //               });
  //             },
  //             items: <String>[
  //               'All',
  //               'NoType',
  //               'Type1',
  //               'Type2',
  //               'Type3',
  //               'Type4'
  //             ].map<DropdownMenuItem<String>>((String value) {
  //               return DropdownMenuItem<String>(
  //                 value: value,
  //                 child: Text(value),
  //               );
  //             }).toList(),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  List<String> titles = ['Sun', 'Moon', 'Star'];

  _myListView() {
    return ListView.builder(
      itemCount: titles.length,
      itemBuilder: (context, index) {
        final item = titles[index];
        return Card(
          child: ListTile(
            title: Text(item),
            onTap: () {
              //                                  <-- onTap
              setState(() {
                titles.insert(index, 'Planet');
              });
            },
            onLongPress: () {
              //                            <-- onLongPress
              setState(() {
                titles.removeAt(index);
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('FolderName')
              .document(uid)
              .collection(uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return new ListView(
                  children: snapshot.data.documents.map((document) {
                return new ListTile(
                  onTap: () {
                    folderName = "General";
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Folder2(
                                  //uid: null,
                                  folderName: folderName,
                                  myData: widget.myData,
                                  updateMyData: widget.updateMyData,
                                )));
                  },
                  title: new Text(document["folderName"].toString()),

                  //subtitle: new Text(document['age'].toString()),
                );
              }).toList());
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _createFolder,
        tooltip: 'Increment',
        child: Icon(Icons.create_new_folder),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<Profile> _folderList(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //print(doc.data);
      return Profile(
          name: doc.data['age'] ?? '',
          age: doc.data['strength'] ?? 0,
          phoneNumber: doc.data['phoneNumber'] ?? '0');
    }).toList();
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
