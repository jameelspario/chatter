import 'dart:io';

import 'package:chatter/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserService _userService = UserService();
  File? _profilePic;
  File? _bannerImage;
  final picker = ImagePicker();
  var _name = '';

  Future getImage(int type) async {     
    final file = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (file != null && type == 0) {
        _profilePic = File(file.path);
      }
      if (file != null && type == 1) {
        _bannerImage = File(file.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        TextButton(
          onPressed: () async{
              await _userService.updateProfile(
                _profilePic, _bannerImage, _name);
                Navigator.pop(context);
          },  
          child: Text("Save", style: TextStyle(color: Colors.white),),
        ),
      ]),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
        child: Form(
          child: Column(
            children: [
              TextButton(
                onPressed: () => getImage(0),
                child: _profilePic == null
                    ? Icon(Icons.person)
                    : Image.file(
                        _profilePic!,
                        height: 100,
                      ),
              ),
              TextButton(
                onPressed: () => getImage(1),
                child: _bannerImage == null
                    ? Icon(Icons.person)
                    : Image.file(
                        _bannerImage!,
                        height: 100,
                      ),
              ),
              TextField(
                onChanged: (val) => {
                  setState(() {
                    _name = val;
                  })
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
