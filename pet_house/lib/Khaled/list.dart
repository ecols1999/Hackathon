import 'package:flutter/material.dart';
//import 'package:profile/khaled/Profile.dart';

class MyList extends StatelessWidget {
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
        body: FollowersList(),
      ),
    );
  }
}

class FollowingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      child: ListView.separated(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('following  $index'),
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

class FollowersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      child: ListView.separated(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Follower  $index'),
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
