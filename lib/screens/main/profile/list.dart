import 'package:chatter/models/post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListPost extends StatefulWidget {
  const ListPost({Key? key}) : super(key: key);

  @override
  State<ListPost> createState() => _ListPostState();
  
}

class _ListPostState extends State<ListPost> {
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<PostModel>>(context);
    return ListView.builder(  
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        if(post==null){
          return Center(
            child: Text("Empty list"),
          );
        }
        
        return ListTile(
          title: Text(post.creator??""),
          subtitle: Text(post.text??""),
        );
      },
    );
  }
}
