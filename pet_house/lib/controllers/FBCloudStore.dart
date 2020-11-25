import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_house/commons/const.dart';
import 'package:pet_house/commons/utils.dart';
import 'package:pet_house/controllers/FBCloudMessaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FBCloudStore {
  static Future<void> sendPostInFirebase(
      String postID,
      String postContent,
      MyProfileData userProfile,
      String postImageURL,
      String title,
      String type) async {
    String postFCMToken;
    if (userProfile.myFCMToken == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      postFCMToken = prefs.get('FCMToken');
    } else {
      postFCMToken = userProfile.myFCMToken;
    }

    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    Firestore.instance.collection('thread').document(postID).setData({
      'postID': postID,
      'userID': user.uid,
      'title': title,
      'type': type,
      'userName': userProfile.myName,
      'userThumbnail': userProfile.myThumbnail,
      'postTimeStamp': DateTime.now().millisecondsSinceEpoch,
      'postContent': postContent,
      'postImage': postImageURL,
      'postLikeCount': 0,
      'postCommentCount': 0,
      'FCMToken': postFCMToken,
      'viewCount': 0,
      'reporters': [],
      'timestamp':  DateFormat.yMMMd().format(DateTime.now())
    });
    /*Firestore.instance.collection('Profile').document(user.uid).setData({
      'name': "name",
      'age': 0,
      'PhoneNumber': 5555,
      'profileImage': 'https://picsum.photos/250?image=9',
    });*/
  }

  //this function is for updating the post text
  static Future<void> postUpdate(
    String postID,
    String postContent, //     String title,
    String titleInside,
    String type,
    
  ) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection('thread')
        .document(postID)
        .updateData
        ({
          'postContent': postContent,
          'title': titleInside,
          'type': type,
          
        });
    
    
  }

  static Future<void> likeToPost(
      String postID, MyProfileData userProfile, bool isLikePost) async {
    if (isLikePost) {
      DocumentReference likeReference = Firestore.instance
          .collection('thread')
          .document(postID)
          .collection('like')
          .document(userProfile.myName);
      await Firestore.instance
          .runTransaction((Transaction myTransaction) async {
        await myTransaction.delete(likeReference);
      });
    } else {
      await Firestore.instance
          .collection('thread')
          .document(postID)
          .collection('like')
          .document(userProfile.myName)
          .setData({
        'userName': userProfile.myName,
        'userThumbnail': userProfile.myThumbnail,
      });
    }
  }

  static Future<void> updatePostLikeCount(DocumentSnapshot postData,
      bool isLikePost, MyProfileData myProfileData) async {
    postData.reference.updateData(
        {'postLikeCount': FieldValue.increment(isLikePost ? -1 : 1)});
    if (!isLikePost) {
      await FBCloudMessaging.instance.sendNotificationMessageToPeerUser(
          '${myProfileData.myName} likes your post',
          '${myProfileData.myName}',
          postData['FCMToken']);
    }
  }

  static Future<void> updatePostCommentCount(
    DocumentSnapshot postData,
  ) async {
    postData.reference
        .updateData({'postCommentCount': FieldValue.increment(1)});
  }

  static Future<void> updateCommentLikeCount(DocumentSnapshot postData,
      bool isLikePost, MyProfileData myProfileData) async {
    postData.reference.updateData(
        {'commentLikeCount': FieldValue.increment(isLikePost ? -1 : 1)});
    if (!isLikePost) {
      await FBCloudMessaging.instance.sendNotificationMessageToPeerUser(
          '${myProfileData.myName} likes your comment',
          '${myProfileData.myName}',
          postData['FCMToken']);
    }
  }

  static Future<void> commentToPost(
      String toUserID,
      String toCommentID,
      String postID,
      String commentContent,
      MyProfileData userProfile,
      String postFCMToken) async {
    String commentID =
        Utils.getRandomString(8) + Random().nextInt(500).toString();
    String myFCMToken;
    if (userProfile.myFCMToken == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      myFCMToken = prefs.get('FCMToken');
    } else {
      myFCMToken = userProfile.myFCMToken;
    }
    Firestore.instance
        .collection('thread')
        .document(postID)
        .collection('comment')
        .document(commentID)
        .setData({
      'toUserID': toUserID,
      'commentID': commentID,
      'toCommentID': toCommentID,
      'userName': userProfile.myName,
      'userThumbnail': userProfile.myThumbnail,
      'commentTimeStamp': DateTime.now().millisecondsSinceEpoch,
      'commentContent': commentContent,
      'commentLikeCount': 0,
      'FCMToken': myFCMToken,
      
    });
    await FBCloudMessaging.instance.sendNotificationMessageToPeerUser(
        commentContent, '${userProfile.myName} was commented', postFCMToken);
  }
}
