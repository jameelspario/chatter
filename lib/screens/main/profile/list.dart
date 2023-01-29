import 'package:chatter/models/post.dart';
import 'package:chatter/models/user.dart';
import 'package:chatter/screens/main/profile/post_item.dart';
import 'package:chatter/services/posts_service.dart';
import 'package:chatter/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListPost extends StatefulWidget {
  final PostModel? post;
  const ListPost(this.post, {Key? key}) : super(key: key);

  @override
  State<ListPost> createState() => _ListPostState();
}

class _ListPostState extends State<ListPost> {
  UserService _userService = UserService();
  PostService _postService = PostService();

  @override
  Widget build(BuildContext context) {
    List<PostModel> posts = Provider.of<List<PostModel>>(context);
    if(widget.post!=null){
      posts.insert(0, widget.post!);
    }
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        if (post.repost) {
          return FutureBuilder<PostModel?>(
              future: _postService.getPostById(post.originalId ?? ''),
              builder: (BuildContext cintext,
                  AsyncSnapshot<PostModel?> snapmshotPost) {
                if (!snapmshotPost.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return mainPost(snapmshotPost.data!, true);
              });
        }
        return mainPost(post, false);
      },
    );
  }

  StreamBuilder<UserModel?> mainPost(PostModel post, bool repost) {
    return StreamBuilder(
        stream: _userService.getUserInfo(post.creator),
        builder:
            (BuildContext context, AsyncSnapshot<UserModel?> snapshotUsers) {
          if (!snapshotUsers.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return StreamBuilder(
              stream: _postService.getcurrentUserLike(post),
              builder:
                  (BuildContext context, AsyncSnapshot<bool> snapshotLike) {
                if (!snapshotLike.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return StreamBuilder(
                    stream: _postService.getcurrentUserRepost(post),
                    builder: (BuildContext context,
                        AsyncSnapshot<bool> snapshotRepost) {
                      if (!snapshotRepost.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return PostItem(
                          post, snapshotUsers, snapshotLike, snapshotRepost, repost);
                    });
              });
        });
  }
}
