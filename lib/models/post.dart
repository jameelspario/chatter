import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String? id;
  final String? creator;
  final String? text;
  final Timestamp? timestamp;
  final String? originalId;
  final bool repost;
  DocumentReference? ref;
  int likesCount;
  int repostCount;

  PostModel({
    this.id,
    this.creator,
    this.text,
    this.originalId,
    this.repost = false,
    this.timestamp,
    this.likesCount = 0,
    this.repostCount = 0,
    this.ref,
  });

  static PostModel from1(DocumentSnapshot doc) {
    PostModel model = fromJson(doc.id, doc.data() as Map<String, dynamic>);
    model.ref = doc.reference;
    return model;
  }

  static PostModel fromJson(id, Map<String, dynamic> json) => PostModel(
        id: id,
        creator: json['creator'],
        text: json['text'],
        timestamp: json['timestamp'],
        likesCount: json['likesCount'] ?? 0,
        repostCount: json['repostCount'] ?? 0,
        repost: json['retpost'] ?? false,
        originalId: json['originalId'] ?? '',
      );
}
