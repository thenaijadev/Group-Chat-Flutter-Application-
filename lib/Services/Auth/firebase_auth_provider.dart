import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/Helper/helper_function.dart';
import 'package:notes/Services/Auth/auth_exception.dart';
import 'package:notes/Services/Auth/auth_provider.dart';
import 'package:notes/Services/Auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:notes/Services/Database/database_service.dart';
import "package:notes/Utilities/firebase_options.dart";

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null) {
        DatabaseService(uid: user.uid).savingUserData(fullName, email);
        await HelperFunctions.saveUserNameSharedPreferences(fullName);
        await HelperFunctions.saveUserEmailSharedPreferences(email);
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == "invaliid-email") {
        throw InvalidEmailAuthException();
      } else if (e.code == "weak-password") {
        throw WeakPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await HelperFunctions.removeUserLoggedInStatus();
      await HelperFunctions.setUSerLoggedInStatus(false);
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;

      if (user != null) {
        final authProvider = FirebaseAuthProvider();
        final AuthUser? authUser = authProvider.currentUser;
        final uid = authUser!.uid;
        QuerySnapshot snapshot =
            await DatabaseService(uid: uid).getUserData(email);

        //Saving the values to shared preferences.

        await HelperFunctions.setUSerLoggedInStatus(true);
        await HelperFunctions.saveUserEmailSharedPreferences(email);
        String userName = snapshot.docs[0]["fullName"];
        await HelperFunctions.saveUserNameSharedPreferences(userName);
        // String? emailSp = await HelperFunctions.getUserEmailSharedPreferences();
        // String? nameSP = await HelperFunctions.getUserNameSharedPreferences();
        // print({nameSP, emailSp});

        return user;
      } else {
        throw GenericAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        throw UserNotFoundAuthException();
      } else if (e.code == "wrong-password") {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
}
