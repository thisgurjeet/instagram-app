import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/models/utils/colors.dart';
import 'package:instagram_app/views/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          title: const Image(
            image: AssetImage(
              'assets/images/instagram_logo.png',
            ),
            color: primaryColor,
            height: 32,
          ),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.messenger_outline))
          ],
        ),

        // streams are used to fetch data from firebase database
        body: StreamBuilder(
          // we are accessing all of our data from posts collection
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => Container(
                      child: PostCard(
                          // render data that is present in the postcard
                          // it will run according to how many posts are present index 0 for firt post and so on..
                          snap: snapshot.data!.docs[index].data()),
                    ));
          },
        ));
  }
}
