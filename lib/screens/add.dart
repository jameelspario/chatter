import 'package:chatter/services/posts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
final PostService _postService = PostService();
  String text = '';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Tweet"),
          actions: <Widget>[
              FlatButton(
                textColor: Colors.white,
                onPressed: () async {
                    _postService.savePost(text);
                    Navigator.pop(context);
                }, 
                child: Text("tweet"))
          ]),
          body: Container(
            padding:EdgeInsets.all(20),
            child: Form(child: TextFormField(
              onChanged: (val) => {
                  setState((){
                    text = val;
                  })
              },
            )
            ),
          
           ),
    );
  }
}