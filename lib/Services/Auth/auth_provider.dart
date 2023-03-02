import 'package:notes/Services/Auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<AuthUser> login({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser(
      {required String email,
      required String password,
      required String fullName});

  Future<void> logOut();

  Future<void> sendEmailVerification();

  Future<void> initialize();
}
