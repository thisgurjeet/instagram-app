import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/views/screens/add_post_screen.dart';
import 'package:instagram_app/views/screens/feed_screen.dart';
import 'package:instagram_app/views/screens/profile_screen.dart';
import 'package:instagram_app/views/screens/search_screen.dart';

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text(''),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
