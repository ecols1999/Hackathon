//this file is for the dictionary page that describes all of Argot's functions

import 'package:flutter/material.dart';

class ProfileData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListViews',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('ListViews')),
        body: IconList(),
      ),
    );
  }
}

//these are the dictionary names right here
final List<String> entries = <String>[
  'Like',
  'Edit',
  'Delete',
  'Favorite',
  'Notebook',
  'Share',
  'Comment',
  'View',
  'Report',
];

//these are the dictionary icons right here
final List<IconData> iconEntries = <IconData>[
  Icons.thumb_up,
  Icons.create,
  Icons.delete,
  Icons.favorite,
  Icons.add,
  Icons.share,
  Icons.mode_comment,
  Icons.child_care,
  Icons.info,
];

//these are the descriptions of what each icon does
final List<String> descript = <String>[
  'Allows you to like other poems.',
  'Allows you to edit your poem.  Be warned that this option becomes unavailable to you once someone comments on your poem.',
  'Allows you to delete your poems.',
  'Allows you to favorite poems.',
  'Allows you to add your poems to a list to be viewed later.',
  'Allows you to share poems to different social media accounts.',
  'Shows how many comments are on a poem.',
  'Shows how many times a certain poem has been viewed.',
  'Allows you to report and unreport a poem.'
];

class IconList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      child: ListView.separated(
        itemCount: 9,
        itemBuilder: (context, index) {
          return ListTile(
            title: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: '${entries[index]}  ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold)),
              WidgetSpan(
                  child: Icon(
                iconEntries[index],
                size: 16,
              )),
              TextSpan(
                  text: '  : ${descript[index]}',
                  style: TextStyle(color: Colors.black))
            ])),
            onTap: () {
              print('Moon');
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }
}
