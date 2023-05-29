import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // to get our user id
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // adding image to firebase storage
  // this function is used to store both profile pics and posts
  Future<String> uploadImagetoStorage(
      String childName, Uint8List file, bool isPost) async {
    // ref is the reference to our file whether it exists or not, now we dont have any
    // creating the child name (where we all this fuction) and the user uid in the firebase as a folder
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    // uploading image to firebase storage
    // put data is used to add uint8list file
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
