import 'package:flutter/material.dart';
import 'package:vendamais/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  

  UserModel get user => _user ?? UserModel();

  void setUser(UserModel newUser) {
    _user = newUser;
    notifyListeners();
  }

  void updateUserPhotoUrl(String newPhotoUrl) {
    if (_user != null) {
      _user = _user!.copyWith(photoUrl: newPhotoUrl);
      notifyListeners();
    }
  }


  void logout() {
    _user = null;
    notifyListeners();
  }
}
