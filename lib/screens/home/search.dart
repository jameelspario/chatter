import 'package:chatter/screens/main/profile/list_users.dart';
import 'package:chatter/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatter/models/user.dart';



class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  UserService _userService = UserService();
  String search = '';

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserModel>>.value(
      value: _userService.queryByName(search),
      initialData: [],
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  search = val;
                });
              },
              decoration: InputDecoration(hintText: 'Search...'),
            ),
          ),
          ListUsers(),
        ],
      ),
    );
  }
}
