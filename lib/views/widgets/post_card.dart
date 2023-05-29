import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/controllers/providers/user_provider.dart';
import 'package:instagram_app/models/utils/colors.dart';
import 'package:instagram_app/models/utils/utils.dart';
import 'package:instagram_app/views/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../controllers/resources/firestore_methods.dart';
import '../screens/comment_screen.dart';

class PostCard extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;

  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentlen = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      commentlen = snap.docs.length;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 16,
          ).copyWith(right: 0),
          child: Row(children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.snap['profImage']),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.snap['username'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shrinkWrap: true,
                            children: [
                              'Delete',
                            ]
                                .map((e) => InkWell(
                                      onTap: () async {
                                        FirestoreMethods()
                                            .deletePost(widget.snap['postId']);
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 16),
                                        child: Text(e),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ));
              },
              icon: const Icon(Icons.more_vert),
            )
          ]),
        ),
        // Post Section
        // wrapping sized box with the stack to show heart icon above the posted image
        GestureDetector(
          onDoubleTap: () async {
            setState(() {
              isLikeAnimating = true;
            });
            await FirestoreMethods().likePost(
                widget.snap['postId'], user?.uid ?? '', widget.snap['likes']);
          },
          child: Stack(alignment: Alignment.center, children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              child: Image.network(
                widget.snap['postUrl'],
                fit: BoxFit.cover,
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isLikeAnimating ? 1 : 0,
              child: LikeAnimation(
                isAnimating: isLikeAnimating,
                duration: const Duration(
                  milliseconds: 400,
                ),
                onEnd: () {
                  setState(() {
                    isLikeAnimating = false;
                  });
                },
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 120,
                ),
              ),
            ),
          ]),
        ),

        // LIKE COMMENT SECTION
        Row(
          children: [
            LikeAnimation(
              // checking if user has uid
              isAnimating: widget.snap['likes'].contains(user?.uid ?? ''),
              smallLike: true,
              child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(widget.snap['postId'],
                        user?.uid ?? '', widget.snap['likes']);
                  },
                  icon: widget.snap['likes'].contains(user?.uid ?? '')
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_border)),
            ),
            IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommentsScreen(
                          postId: widget.snap['postId'].toString(),
                        ))),
                icon: const Icon(
                  Icons.comment_outlined,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                )),
            Expanded(
                child: Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {},
              ),
            ))
          ],
        ),
        //Description and no of comments
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // likes are array so we have to use string interroplation and .length
                '${widget.snap['likes'].length} likes',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8),
                child: RichText(
                  text: TextSpan(
                      style: const TextStyle(
                        color: primaryColor,
                      ),
                      children: [
                        TextSpan(
                            text: widget.snap['username'],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: '  ${widget.snap['description']}',
                        )
                      ]),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'View all $commentlen comments',
                    style: const TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  DateFormat.yMMMd()
                      .format(widget.snap['datePublished'].toDate())
                      .toString(),

                  // Assuming widget.snap['datePublished'] is already a DateTime object

                  style: const TextStyle(fontSize: 16, color: secondaryColor),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
