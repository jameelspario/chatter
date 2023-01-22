import 'package:chatter/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? _userFromFirebase(User? user){
    return user!=null?UserModel(id:user.uid):null;
  }

  Stream<UserModel?> get user{
    return _auth.authStateChanges().map((event) => 
    _userFromFirebase(event));
  }

  Future signUp(email, password) async{
      try{
        UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
         ); 
         await FirebaseFirestore.instance
         .collection("users")
         .doc(user.user?.uid)
         .set({'name':email, 'email':email});
          _userFromFirebase(user.user);
      }catch(e){
          print(e);
      }
  }

  void signIn(email, password) async{
      try{
        User user = await _auth.signInWithEmailAndPassword(
          email: email,
         password: password
         ) as User;
         _userFromFirebase(user);
      }catch(e){
          print(e);
      }
  }

  Future signOut() async{

try{
    return await _auth.signOut();
}catch(e){
  print(e.toString());
}
  }

}