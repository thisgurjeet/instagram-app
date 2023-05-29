import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_app/models/user.dart' as model;
import 'package:instagram_app/controllers/resources/storage_methods.dart';

class AuthMethods {
  // for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // to store data in firebase database
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// getUserDetails function that would be called in userProvider class to refresh user
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  // signup user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // cred gives us uid of a user

        // calling storage methods function to upload profile picture
        String photoUrl = await StorageMethods()
            .uploadImagetoStorage('profilePics', file, false);

        // add user to our database

        model.User user = model.User(
          username: username,
          email: email,
          uid: cred.user!.uid,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );
        // we are creating a user collection if it does not already exist
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = 'success';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        res = 'The email is badly formatted';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginuser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occured';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'sucess';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
