import 'package:flutter/material.dart';

import '../../domain/entities/user_profile.dart';

class ZimoStore extends ChangeNotifier {
  ZimoStore._();

  static final ZimoStore instance = ZimoStore._();

  final List<UserProfile> _users = [];
  UserProfile? _currentUser;

  List<UserProfile> get users => List.unmodifiable(_users);
  UserProfile? get currentUser => _currentUser;

  void setCurrentUser(UserProfile user) {
    _currentUser = user;
    notifyListeners();
  }

  void addUser(UserProfile user) {
    _users.add(user);
    _currentUser = user;
    notifyListeners();
  }

  void setUsers(List<UserProfile> users) {
    _users
      ..clear()
      ..addAll(users);
    notifyListeners();
  }

  void updateCurrentUser(UserProfile user) {
    _currentUser = user;
    final index = _users.indexWhere((item) => item.id == user.id);
    if (index >= 0) {
      _users[index] = user;
    }
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
