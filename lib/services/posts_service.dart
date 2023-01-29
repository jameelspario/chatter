import 'dart:developer';

import 'package:chatter/models/post.dart';
import 'package:chatter/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiver/iterables.dart';

class PostService {
  List<PostModel> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) =>
            PostModel.from1(doc))
        .toList();
  }

PostModel? _postFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot.exists ? 
        PostModel.from1(snapshot)
        : null;
  }

  Future savePost(text) async {
    await FirebaseFirestore.instance.collection("posts").add({
      'text': text,
      'creator': FirebaseAuth.instance.currentUser?.uid,
      'timestamp': FieldValue.serverTimestamp(),
      // 'likesCount':0,
    });
  }

   Future reply(PostModel post, String text) async {
    if(text=='')
      return;

    await post.ref?.collection("replies").add({
      'text': text,
      'creator': FirebaseAuth.instance.currentUser?.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'repost':false,
      // 'likesCount':0,
    });
  }


  Future likePost(PostModel post, bool current) async {
    if (current) {
      post.likesCount = post.likesCount - 1;
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection("likes")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .delete();
    } else {
      post.likesCount = post.likesCount + 1;
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection("likes")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({});
    }
  }

  Future retweet(PostModel post, bool current) async {
    if (current) {
      post.repostCount = post.repostCount - 1;
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection("reposts")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .delete();

      await FirebaseFirestore.instance
          .collection("posts")
          .where('originalId', isEqualTo: post.id)
          .where('creator', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get()
          .then((value) => {
                if (value.docs.isNotEmpty){
                  
                    FirebaseFirestore.instance
                        .collection('posts')
                        .doc(value.docs[0].id)
                        .delete()
                  }
              });

      return;
    }

    post.repostCount = post.repostCount + 1;
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection("reposts")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({});

    await FirebaseFirestore.instance.collection("posts").add({
      'creator': FirebaseAuth.instance.currentUser?.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'repost': true,
      'originalId': post.id
    });
  }

  Stream<bool> getcurrentUserLike(PostModel post) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection("likes")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map((snap) {
      return snap.exists;
    });
  }

  Stream<bool> getcurrentUserRepost(PostModel post) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection("reposts")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map((snap) {
      return snap.exists;
    });
  }

  Future<PostModel?> getPostById(String id) async{
    DocumentSnapshot snap = 
    await FirebaseFirestore.instance.collection("posts").doc(id).get();

    return _postFromSnapshot(snap);
  }

  Stream<List<PostModel>> getPostByUser(uid) {
    return FirebaseFirestore.instance
        .collection("posts")
        .where('creator', isEqualTo: uid)
        .snapshots()
        .map(_postListFromSnapshot);
  }

  Future<List<PostModel>> getReplies(PostModel post) async {
      QuerySnapshot query = await post.ref!.collection("replies")
      .orderBy('timestamp', descending: true)
      .get();

      return _postListFromSnapshot(query);

  }
  Future<List<PostModel>> getFeed() async {
    List<String> users = await UserService()
        .getUsersFollowing(FirebaseAuth.instance.currentUser?.uid);

    var splitUsers = partition<dynamic>(users, 10);
    inspect(splitUsers);

    List<PostModel> feedList = [];

    for (int i = 0; i < splitUsers.length; i++) {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection("posts")
          .where('creator', whereIn: splitUsers.elementAt(i))
          .orderBy('timestamp', descending: true)
          .get();

      feedList.addAll(_postListFromSnapshot(query));
    }

    feedList.sort((a, b) {
      var adate = a.timestamp;
      var bdate = b.timestamp;
      return bdate!.compareTo(adate!);
    });
    return feedList;
  }
}
