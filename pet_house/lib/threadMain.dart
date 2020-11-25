import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_house/commons/const.dart';
import 'package:pet_house/contentDetail.dart';
import 'package:pet_house/subViews/threadItem.dart';
import 'package:pet_house/writePost.dart';
//import 'main.dart';

import 'commons/utils.dart';

class ThreadMain extends StatefulWidget {
  final MyProfileData myData;
  final ValueChanged<MyProfileData> updateMyData;
  ThreadMain({this.myData, this.updateMyData});
  @override
  State<StatefulWidget> createState() => _ThreadMain();
}

class _ThreadMain extends State<ThreadMain> {
  bool _isLoading = false;

  void _writePost() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WritePost(
                  myData: widget.myData,
                )));
  }

  String type;
  String title;

  String dropdownValue = 'All';
  TextEditingController search;
  _searchBar() {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Expanded(
          //   flex: 4,
          //   child: TextFormField(
          //     //autofocus: true,

          //     decoration: InputDecoration(
          //       border: InputBorder.none,
          //       hintText: 'Search ...',
          //       hintMaxLines: 4,
          //     ),
          //     controller: search,

          //     keyboardType: TextInputType.multiline,
          //     maxLines: null,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 250.0),
            child: DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_downward),
              iconSize: 30,
              elevation: 16,
              style: TextStyle(color: Colors.blueAccent),
              underline: Container(
                height: 3,
                color: Colors.blueAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                  type = newValue;
                  if (type == 'All') type = null;
                });
              },
              items: <String>[
                'All',
                'General',
                'Free Verse',
                'Haiku',
                'Blank Verse',
                'Narrative',
                'Epic',
                'Lyric',
                'Rhyme',
                'Romanticism',
                'Shakespearean',
                'ABC'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _searchBar(),
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('thread')
                    .where('type', isEqualTo: type)
                    // .where('postLikeCount', isEqualTo: 0)
                    .where('title', isEqualTo: search)
                    .orderBy('postTimeStamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LinearProgressIndicator();
                  return Stack(
                    children: <Widget>[
                      snapshot.data.documents.length > 0
                          ? ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _writePost,
        tooltip: 'Increment',
        child: Icon(Icons.create),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

//this function increments the views button
  void incrementViews(var data) async {
    data.reference.updateData({'viewCount': FieldValue.increment(1)});
    //data.reference.updateData({'viewCount': FieldValue.increment(1)});
  }

  void _moveToContentDetail(DocumentSnapshot data) {
    incrementViews(data);
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
