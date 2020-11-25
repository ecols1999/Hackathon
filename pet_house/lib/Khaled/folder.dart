import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_house/Khaled/profile2.dart';
import 'package:pet_house/commons/const.dart';
import 'package:pet_house/contentDetail.dart';
import 'package:pet_house/subViews/threadItem.dart';
import 'package:pet_house/writePost.dart';
//import 'main.dart';

import '../commons/utils.dart';
import '../tasks.dart';

class Folder2 extends StatefulWidget {
  final MyProfileData myData;
  String folderName;
  final ValueChanged<MyProfileData> updateMyData;
  Folder2({this.myData, this.updateMyData, this.folderName});
  @override
  State<StatefulWidget> createState() => _Folder();
}

class _Folder extends State<Folder2> {
  bool _isLoading = false;
  Folder2 objec;

  // String folderName = objec.folderName;

  void _writePost() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WritePost(
                  myData: widget.myData,
                )));
  }

  // void _createFolder() {
  //   Firestore.instance
  //       .collection('FolderName')
  //       .document("333")
  //       .setData({'folderName': folderName});
  // }

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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: new StreamBuilder<QuerySnapshot>(
  //         stream: Firestore.instance.collection('FolderName').snapshots(),
  //         builder:
  //             (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //           if (!snapshot.hasData) {
  //             return Center(child: CircularProgressIndicator());
  //           } else {
  //             return new ListView(
  //                 children: snapshot.data.documents.map((document) {
  //               return new ListTile(
  //                 onTap: () {},
  //                 title: new Text(document['folderName'].toString()),

  //                 //subtitle: new Text(document['age'].toString()),
  //               );
  //             }).toList());
  //           }
  //         }),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: _createFolder,
  //       tooltip: 'Increment',
  //       child: Icon(Icons.create_new_folder),
  //     ), // This trailing comma makes auto-formatting nicer for build methods.
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //  _searchBar(),
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('FolderName')
                    .document(uid)
                    .collection(uid)
                    .document("General")
                    .collection(uid)
                    //.where('type', isEqualTo: type)
                    //.where('favorite', isEqualTo: 1)
                    // .where('title', isEqualTo: search)
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
                                          fontSize: 16,
                                          color: Colors.grey[700]),
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
            // StreamBuilder<QuerySnapshot>(
            //     stream: Firestore.instance
            //         .collection('Profile')
            //         // .document(uid)
            //         // .collection(uid)
            //         //.where('type', isEqualTo: type)
            //         //.where('favorite', isEqualTo: 1)
            //         // .where('title', isEqualTo: search)
            //         //.orderBy('postTimeStamp', descending: true)
            //         .snapshots(),
            //     builder: (context, snapshot) {
            //       if (!snapshot.hasData) return LinearProgressIndicator();
            //       return Stack(
            //         children: <Widget>[
            //           snapshot.data.documents.length > 0
            //               ? _folderList
            //               : Container(
            //                   child: Center(
            //                       child: Column(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: <Widget>[
            //                       Icon(
            //                         Icons.error,
            //                         color: Colors.grey[700],
            //                         size: 64,
            //                       ),
            //                       Padding(
            //                         padding: const EdgeInsets.all(14.0),
            //                         child: Text(
            //                           'There is no post',
            //                           style: TextStyle(
            //                               fontSize: 16,
            //                               color: Colors.grey[700]),
            //                           textAlign: TextAlign.center,
            //                         ),
            //                       ),
            //                     ],
            //                   )),
            //                 ),
            //           Utils.loadingCircle(_isLoading),
            //         ],
            //       );
            //     }),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _createFolder,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.create_new_folder),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
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
