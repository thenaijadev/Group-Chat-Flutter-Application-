import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  const AuthUser({required this.isEmailVerified, this.email, this.uid});
  final bool isEmailVerified;
  final String? email;
  final String? uid;

  factory AuthUser.fromFirebase(user) {
    print({user.email, user.emailVerified, user.uid});
    return AuthUser(
        isEmailVerified: user.emailVerified, email: user.email, uid: user.uid);
  }
}
