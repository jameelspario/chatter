
import 'package:chatter/screens/auth/login.dart';
import 'package:chatter/screens/add.dart';
import 'package:chatter/screens/main/Home.dart';
import 'package:chatter/screens/main/profile/edit.dart';
import 'package:chatter/screens/main/profile/profile.dart';
import 'package:chatter/screens/main/profile/replies.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/User.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    if(user==null){
      return Login();
    }

    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/':(context) => Home(),
        '/add' :(context) => Add(),
        '/profile':(context) => Profile(),
        '/edit_profile':(context) => EditProfile(),
        '/replies':(context) => Replies()
        
      },
    );
  }
}