import 'package:flutter/foundation.dart';
import 'package:instagram_app/models/user.dart';
import 'package:instagram_app/controllers/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  final AuthMethods _authMethods = AuthMethods();

  User? get getUser => _user;

// refresh user everytime to manage state
  Future<void> refreshUser() async {
    User? user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
