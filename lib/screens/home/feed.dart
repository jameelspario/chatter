import 'package:chatter/models/post.dart';
import 'package:chatter/screens/main/profile/list.dart';
import 'package:chatter/services/posts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final PostService _postService = PostService();
  @override
  Widget build(BuildContext context) {
    return FutureProvider<List<PostModel>>.value(
      value: _postService.getFeed(),
      initialData: [],
      child: Scaffold(body: ListPost(null)),
    );
  }
}
