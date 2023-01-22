import 'package:chatter/screens/home/feed.dart';
import 'package:chatter/screens/home/search.dart';
import 'package:chatter/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> {
  final AuthService _authService = AuthService();
  int _currentIndex = 0;
  final List<Widget> _children = [Feed(), Search()];

  void onTabPress(int index) {
    setState(() {   
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('widgets ${_children.length}');
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        // actions: <Widget>[
        //   FlatButton.icon(
        //     onPressed: () async {},
        //     icon: Icon(Icons.person),
        //     label: Text("Signout"),
        //   )
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("heading"),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              title: Text("Profile"),
              onTap: () {
                Navigator.pushNamed(context, '/profile', arguments: FirebaseAuth.instance.currentUser?.uid);
              },
            ),
            ListTile(
              title: Text("Logout"),
              onTap: () {
                _authService.signOut();
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabPress,
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'search'),
        ],
      ),
      body: _children[_currentIndex],
    );
  }
}
