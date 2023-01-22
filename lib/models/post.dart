
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel{
  final String? id;
  final String? creator;
  final String? text;
  final Timestamp? timestamp;

  PostModel({this.id, this.creator, this.text, this.timestamp});

  static PostModel fromJson(id, Map<String, dynamic> json) => PostModel(
    id:id,
    creator: json['creator'],
    text: json['text'],
    timestamp: json['timestamp'],

  );

}