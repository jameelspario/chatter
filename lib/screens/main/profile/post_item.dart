import 'package:chatter/models/user.dart';
import 'package:chatter/models/post.dart';
import 'package:chatter/services/posts_service.dart';
import 'package:flutter/material.dart';

class PostItem extends StatefulWidget {
  final PostModel post;
  final AsyncSnapshot<UserModel?> snapshotUsers;
  final AsyncSnapshot<bool> snapshotLike;
  final AsyncSnapshot<bool> snapshotRepost;
  final bool repost;
  
  const PostItem(this.post, this.snapshotUsers, this.snapshotLike, this.snapshotRepost, this.repost, {Key? key}) : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  final PostService _postService = PostService();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(widget.snapshotRepost.hasData || widget.repost) Text("Retweet"),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                widget.snapshotUsers.data!.profileUrl != ''
                    ? CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            NetworkImage(widget.snapshotUsers.data!.profileUrl!),
                      )
                    : Icon(
                        Icons.person,
                        size: 40,
                      ),
                SizedBox(
                  width: 10,
                ),
                Text(widget.snapshotUsers.data!.name!)
              ],
            )
          ],
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.post.text ?? ''),
                SizedBox(
                  height: 20,
                ),
                Text(widget.post.timestamp!.toDate().toString()),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pushNamed(context, '/replies', arguments: widget.post ),
                          icon: Icon(Icons.chat_bubble_outline,
                            color: Colors.blue,
                            size: 30.0,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _postService.retweet(widget.post, widget.snapshotRepost.data??false),
                          icon: Icon(
                            widget.snapshotRepost.data! ? Icons.cancel : Icons.repeat,
                            color: Colors.blue,
                            size: 30.0,
                          ),
                        ),
                        Text(widget.post.repostCount.toString())
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _postService.likePost(
                                widget.post, widget.snapshotLike.data ?? false);
                          },
                          icon: Icon(
                            widget.snapshotLike.data!
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.blue,
                            size: 30.0,
                          ),
                        ),
                        Text(widget.post.likesCount.toString())
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
