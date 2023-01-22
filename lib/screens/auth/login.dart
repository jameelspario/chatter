import 'package:chatter/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _authService = AuthService();

  var email = '';
  var password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Form(child: Column(
            children: [
              TextFormField(
                onChanged: (val) => setState(() {
                  email = val;
                }),
              ),
              TextFormField(
                onChanged: (val) => setState(() {
                  password = val;
                }),
              ),
              ElevatedButton(
                onPressed: () async=>{ _authService.signUp(email, password)},
              child: Text("Signup"),
              ),
              ElevatedButton(
                onPressed: () async =>{
                  _authService.signIn(email, password)
              },
              child: Text("Login"),
              ),
            ],
          ),
          ),
        ),
    );
  }

  Future signUp() async{
    print({"$email | $password"});
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
         password: password
         );
      }catch(e){
          print(e);
      }
  }
}