import 'package:chatter/models/post.dart';
import 'package:chatter/models/user.dart';
import 'package:chatter/screens/main/profile/list.dart';
import 'package:chatter/services/posts_service.dart';
import 'package:chatter/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final PostService _postService = PostService();
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    final String uid = ModalRoute.of(context)!.settings.arguments as String;

    return MultiProvider(
      providers: [
        StreamProvider<List<PostModel>>.value(
            value: _postService.getPostByUser(uid), initialData: []),
        StreamProvider<UserModel?>.value(
            value: _userService.getUserInfo(uid), initialData: null),
      ],
      child: Scaffold(
        body: DefaultTabController(
            length: 2,
            child: NestedScrollView(
                headerSliverBuilder: (context, _) {
                  return [
                    SliverAppBar(
                      floating: false,
                      pinned: true,
                      expandedHeight: 130,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Image.network(
                          Provider.of<UserModel?>(context)?.bannerUrl ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Provider.of<UserModel?>(context)?.profileUrl !=
                                          ''
                                      ? CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(
                                              Provider.of<UserModel>(context)
                                                  .profileUrl!),
                                        )
                                      : Icon(Icons.person, size: 50),
                                  // Image.network(
                                  //   Provider.of<UserModel>(context)
                                  //           .profileUrl ??
                                  //       '',
                                  //   height: 60,
                                  //   fit: BoxFit.cover,
                                  // ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/edit_profile');
                                      },
                                      child: Text("Edit Profile"))
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    Provider.of<UserModel>(context).name ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
                    )
                  ];
                },
                body: ListPost())),
      ),
    );
  }
}

/*
StreamProvide r<List<PostModel>>.value(
      value: _postService.getPostByUser(FirebaseAuth.instance.currentUser?.uid),
      initialData: [],
      child: Scaffold(
        body: ListPost(),
      ),
    );
*/
