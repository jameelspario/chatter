import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class UtilsService{

  Future<String> uploadFile(File image, String path) async{
      String result = '';
       FirebaseStorage storage = FirebaseStorage.instance;
       Reference ref = storage.ref(path);
       UploadTask uploadTask = ref.putFile(image);
       await uploadTask.whenComplete(() => null);
        await ref.getDownloadURL().then((fileUrl) => {
          result = fileUrl
        });
        
       return result;
  }
}