import 'package:flutter/material.dart';
import 'package:instagram_app/controllers/providers/user_provider.dart';

import 'package:instagram_app/models/utils/dimensions.dart';
import 'package:provider/provider.dart';

class Responsivelayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const Responsivelayout({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  }) : super(key: key);

  @override
  State<Responsivelayout> createState() => _ResponsivelayoutState();
}

class _ResponsivelayoutState extends State<Responsivelayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webScreenSize) {
        // web screen
        return widget.webScreenLayout;
      } else {
        // mobile screen
        return widget.mobileScreenLayout;
      }
    });
  }
}
