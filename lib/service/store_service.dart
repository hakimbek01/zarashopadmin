import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StoreService {

  static final _storage=FirebaseStorage.instance.ref();
  static const _folder="post_image";
  static const _folderAdvertising="reklama_image";


  static Future<List> uploadImages(List _image) async {
    List? list=[];

    for (var a in _image) {
      String imageName="image_${DateTime.now()}";
      Reference reference=_storage.child(_folder).child(imageName);
      final UploadTask uploadTask= reference.putFile(a);
      TaskSnapshot taskSnapshot=await uploadTask.whenComplete(() => {});
      final String downloadUrl=await taskSnapshot.ref.getDownloadURL();
      list.add(downloadUrl);
    }

    return list;
  }

  static Future<String?> uploadImage(File image) async {
    String imgName="image_"+DateTime.now().toString();
    var firebaseStorageRef = _storage.child(_folder).child(imgName);
    var uploadTask=firebaseStorageRef.putFile(image);
    final TaskSnapshot taskSnapshot=await uploadTask.whenComplete(() => {});
    String downloadUrl= await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String?> uploadAdvertisingImage(File image) async {
    String imgName="image_"+DateTime.now().toString();
    var firebaseStorageRef = _storage.child(_folderAdvertising).child(imgName);
    var uploadTask=firebaseStorageRef.putFile(image);
    final TaskSnapshot taskSnapshot=await uploadTask.whenComplete(() => {});
    String downloadUrl= await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<void> removeImage(List imageUrl) async {
    print("imageUrl: $imageUrl");
    for (var a in imageUrl) {
      await _storage.storage.refFromURL(a).delete();
    }
  }

}