import 'package:flutter/foundation.dart';

class User {
  final String name;
  final String email;
  final String passwold;
  final bool isConnect;

  User({
    this.name,
    @required this.email,
    @required this.passwold,
    this.isConnect = false,
  });
}
