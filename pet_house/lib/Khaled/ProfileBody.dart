import 'package:flutter/material.dart';
import 'package:pet_house/Khaled/ViewPoem.dart';
import 'package:pet_house/Khaled/insidepage.dart';
import 'package:pet_house/Khaled/list.dart';
import 'package:pet_house/Khaled/WritePoem.dart';
import 'package:pet_house/commons/const.dart';
import 'package:pet_house/subViews/changeUserIcon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BodyLayout extends StatefulWidget {
  @override
  BodyLayoutState createState() {
    return new BodyLayoutState();
  }
}

class BodyLayoutState extends State<BodyLayout> {
  // The GlobalKey keeps track of the visible state of the list items
  // while they are being animated.
  final GlobalKey<AnimatedListState> keyList = GlobalKey();

  // backing data
  List<String> dataList = ['Poem1'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 490,
          child: AnimatedList(
            // Give the Animated list the global key
            key: keyList,
            initialItemCount: dataList.length,
            // Similar to ListView itemBuilder, but AnimatedList has
            // an additional animation parameter.
            itemBuilder: (context, index, animation) {
              // Breaking the row widget out as a method so that we can
              // share it with the _removeSingleItem() method.
              return ceateItem(dataList[index], animation);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                heroTag: "hero1",
                onPressed: () {
                  insertItem();
                },
                backgroundColor: Colors.red[600],
                child: Icon(Icons.add),
              ),
              FloatingActionButton(
                heroTag: "hero2",
                onPressed: () {
                  removeItem();
                },
                backgroundColor: Colors.red[600],
                child: Icon(Icons.delete_sweep),
              ),
            ],
          ),
        ),
        // RaisedButton(
        //   child: Text('Add Poem', style: TextStyle(fontSize: 20)),
        //   onPressed: () {
        //     _insertSingleItem();
        //   },
        // ),

        // RaisedButton(
        //   child: Text('Remove Poem', style: TextStyle(fontSize: 20)),
        //   onPressed: () {
        //     _removeSingleItem();
        //   },
        // )
      ],
    );
  }

  // This is the animated row with the Card.
  Widget ceateItem(String item, Animation animation) {
    TextEditingController controller;
    int likes = 0;
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        elevation: 5.0,
        child: InkWell(
          // child: Draggable(
          //   onDragEnd: (drag) {
          //     removeItem();
          //   },
          // ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewPoem()),
            );
            print('tapped');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Expanded(
                //   flex: 1,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: <Widget>[
                //       Padding(
                //         padding: const EdgeInsets.all(0),
                //         child: Text(
                //           "$item",
                //           style: TextStyle(
                //             color: Colors.blueAccent,
                //             fontSize: 18.0,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //       // SizedBox(
                //       //   height: 5.0,
                //       // ),
                //       // FlatButton(
                //       //     onPressed: () {},
                //       //     color: Colors.grey[200],
                //       //     child: Text(
                //       //       "View",
                //       //       style: TextStyle(
                //       //         fontSize: 20.0,
                //       //         color: Colors.lightBlueAccent,
                //       //       ),
                //       //     )),
                //     ],
                //   ),
                // ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Poems",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        child: TextField(
                          controller: controller,
                        ),
                      ),
                      // FlatButton(
                      //     onPressed: () {},
                      //     color: Colors.grey[200],
                      //     child: Text(
                      //       "5200",
                      //       style: TextStyle(
                      //         fontSize: 20.0,
                      //         color: Colors.lightBlueAccent,
                      //       ),
                      //     )),
                    ],
                  ),
                ),
                Expanded(
                  // flex: 1,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30.0,
                        width: 60.0,
                        child: FloatingActionButton(
                            heroTag: "hero4",
                            child: Icon(Icons.thumb_up),
                            onPressed: () {
                              setState(() {
                                likes += 1;
                              });
                            }),
                      ),
                      // Text(
                      //   "Followers",
                      //   style: TextStyle(
                      //     color: Colors.blueAccent,
                      //     fontSize: 22.0,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      SizedBox(
                        height: 5.0,
                      ),
                      SizedBox(
                        height: 30.0,
                        width: 60.0,
                        child: FlatButton(
                            onPressed: () {},
                            color: Colors.grey[200],
                            child: Text(
                              "$likes",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.lightBlueAccent,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  // flex: 1,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30.0,
                        width: 60.0,
                        child: FloatingActionButton(
                          heroTag: "hero3",
                          child: Icon(Icons.share),
                          onPressed: () {},
                          backgroundColor: Colors.amberAccent,
                        ),
                      ),
                      // Text(
                      //   "Follow",
                      //   style: TextStyle(
                      //     color: Colors.blueAccent,
                      //     fontSize: 22.0,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      SizedBox(
                        height: 5.0,
                      ),
                      SizedBox(
                        height: 30.0,
                        width: 60.0,
                        child: FlatButton(
                            onPressed: () {},
                            color: Colors.grey[200],
                            child: Text(
                              "100",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.lightBlueAccent,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void insertItem() {
    String newItem = "Poem";
    int insertIndex = 0;
    dataList.insert(insertIndex, newItem);
    keyList.currentState.insertItem(insertIndex);
  }

  void removeItem() {
    int removeIndex = 0;
    String removedItem = dataList.removeAt(removeIndex);

    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return ceateItem(removedItem, animation);
    };
    keyList.currentState.removeItem(removeIndex, builder);
  }
}

// Future<void> _updateMyData(String newName, String newThumbnail) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('myName', newName);
//     prefs.setString('myThumbnail', newThumbnail);
//     setState(() {
//       _myThumbnail = newThumbnail;
//       _myName = newName;
//     });
//     MyProfileData newMyData =
//         MyProfileData(myName: newName, myThumbnail: newThumbnail);
//    widget.updateMyData(newMyData);
//    widfet.

//   }

//   void _showDialog() async {
//     TextEditingController _changeNameTextController = TextEditingController();
//     await showDialog(
//       context: context,
//       child: new AlertDialog(
//         contentPadding: const EdgeInsets.all(16.0),
//         content: new Row(
//           children: <Widget>[
//             new Expanded(
//               child: new TextField(
//                 autofocus: true,
//                 decoration: new InputDecoration(
//                     labelText: 'Type your other nick name',
//                     labelStyle: TextStyle(fontWeight: FontWeight.bold),
//                     hintText: 'ex) loydkim',
//                     icon: Icon(Icons.edit)),
//                 controller: _changeNameTextController,
//               ),
//             )
//           ],
//         ),
//         actions: <Widget>[
//           new FlatButton(
//               child: const Text('CANCEL'),
//               onPressed: () {
//                 Navigator.pop(context);
//               }),
//           new FlatButton(
//               child: const Text('SUBMIT'),
//               onPressed: () {
//                 _updateMyData(
//                     _changeNameTextController.text, widget.myData.myThumbnail);
//                 Navigator.pop(context);
//               })
//         ],
//       ),
//     );
//   }
// }
