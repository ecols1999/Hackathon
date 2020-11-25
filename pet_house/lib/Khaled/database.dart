import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:projectname/Khaled/profile2.dart';
import 'package:pet_house/Khaled/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference profileCollection =
      Firestore.instance.collection('Profile');

  // final CollectionReference folderCollection =
  //   Firestore.instance.collection('Profile');

  Future<void> updateUserData(
      String name, int age, int phoneNumber, String prfileImage) async {
    return await profileCollection.document(uid).setData({
      'name': name,
      'age': age,
      'PhoneNumber': phoneNumber,
      'profileImage': prfileImage,
    });
  }

  // brew list from snapshot
  // List<UserData> _brewListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.documents.map((doc) {
  //     //print(doc.data);
  //     return UserData(
  //         name: doc.data['name'] ?? 'khaled',
  //         age: doc.data['age'] ?? '13',
  //         phoneNumber: doc.data['phoneNumber'] ?? '0');
  //   }).toList();
  // }

  // user data from snapshots
  UserData userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data['name'] ?? 'Khaled',
        age: snapshot.data['age'] ?? '33',
        phoneNumber: snapshot.data['phoneNumber'] ?? '0',
        profileImage: snapshot.data['profileImage'] ??
            'https://picsum.photos/250?image=9');
  }

  // get brews stream
  // Stream<List<Profile>> get brews {
  //   return profileCollection.snapshots().map(_brewListFromSnapshot);
  // }

  // get user doc stream
  Stream<UserData> get userData {
    return profileCollection
        .document(uid)
        .snapshots()
        .map(userDataFromSnapshot);
  }
}
