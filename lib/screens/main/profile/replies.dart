import 'package:chatter/models/post.dart';
import 'package:chatter/screens/main/profile/list.dart';
import 'package:chatter/services/posts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Replies extends StatefulWidget {
  const Replies({Key? key}) : super(key: key);

  @override
  State<Replies> createState() => _RepliesState();
}

class _RepliesState extends State<Replies> {
  PostService _postService = PostService();
  String text = '';
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PostModel args = ModalRoute.of(context)?.settings.arguments as PostModel;

    return FutureProvider<List<PostModel>>.value(
        value: _postService.getReplies(args),
        initialData: [],
        child: Scaffold(
          body: Container(
            child: Column(
              children: [
                Expanded(
                  child: ListPost(args),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Form(child: TextFormField(
                        controller:_controller,
                        onChanged: (val){
                          setState(() {
                            text = val;
                          });
                        },
                      )),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () async{
                          await _postService.reply(args, text);
                          _controller.text = '';
                          setState(() {
                            text = '';
                          });
                        },
                        child: Text("Reply"),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
