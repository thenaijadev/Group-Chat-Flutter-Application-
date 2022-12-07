import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  const AuthUser({required this.isEmailVerified});
  final bool isEmailVerified;

  factory AuthUser.fromFirebase(user) {
    return AuthUser(isEmailVerified: user.emailVerifed);
  }
}
