import 'dart:collection';
import 'dart:io';

import 'package:chatter/models/user.dart';
import 'package:chatter/services/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  UtilsService _utilsService = UtilsService();

  UserModel? _userFromFirebaseSnapshot(DocumentSnapshot snapshot){
      return snapshot!=null?
      UserModel.fromJson(snapshot.id, snapshot.data() as Map<String, dynamic>):null;
  }

  List<UserModel> _userListFromQuerySnapshot(QuerySnapshot snapshot){
      return snapshot
      .docs
      .map((doc) => 
           UserModel.fromJson(doc.id, doc.data() as Map<String, dynamic>)
      ).toList();
  }

  Stream<UserModel?> getUserInfo(uid){
      return FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .snapshots()
      .map(_userFromFirebaseSnapshot);
  }

  Future<List<String>> getUsersFollowing(uid) async{
      QuerySnapshot query = await FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .collection("following")
      .get();

      final users = query.docs.map((doc) => doc.id).toList();
      return users; 

  }

  Stream<List<UserModel>> queryByName(search){
      return FirebaseFirestore.instance
      .collection("users")
      .orderBy('name')
      .startAt([search])
      .endAt([search + '\uf8ff'])
      .limit(10)
      .snapshots()
      .map(_userListFromQuerySnapshot);
  }

  Future<void> updateProfile(File? avtar, File? _banner, String name) async {
    String profileUrl = '';
    String bannerUrl = '';

    if (avtar != null) {
      profileUrl = await _utilsService.uploadFile(avtar,
          'user/profile/${FirebaseAuth.instance.currentUser?.uid}/profile');
    }

    if (_banner != null) {
      bannerUrl = await _utilsService.uploadFile(_banner,
          'user/profile/${FirebaseAuth.instance.currentUser?.uid}/banner');
    }

    Map<String, Object> data = new HashMap();
    if (name != '') {
      data['name'] = name;
    }

    if (profileUrl != '') {
      data['profile'] = profileUrl;
    }

    if (bannerUrl != '') {
      data['banner'] = bannerUrl;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(data);
  }

  Stream<bool> isFollowing(uid, otherId){
      return FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .collection("following")
      .doc(otherId)
      .snapshots()
      .map((snap){ return snap.exists; });
  }

  Future<void> follow(uid) async{
     await FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("following")
      .doc(uid)
      .set({});

      await FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .collection("followers")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .set({});
  }


Future<void> unfollow(uid) async{
     await FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("following")
      .doc(uid)
      .delete();

      await FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .collection("followers")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .delete();
  }



}
