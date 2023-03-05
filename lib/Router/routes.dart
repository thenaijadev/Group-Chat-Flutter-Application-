import 'package:go_router/go_router.dart';
import 'package:notes/Screens/chat_screen.dart';
import 'package:notes/Screens/onboarding_screen_logic.dart';
import 'package:notes/Screens/profile_screen.dart';
import 'package:notes/Screens/search_screen.dart';
import '../Screens/home.dart';
import "../Screens/registration_screen.dart";
import '../Screens/verify_email.dart';
import '../Screens/login_screen.dart';
import '../Helper/helper_function.dart';
import '../Screens/group_info_screen.dart';

// GoRouter configuration

class MyRouter {
  static bool isLoggedIn() {
    HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        if (value) {
          return value;
        }
      }
    });
    return false;
  }

  static final router = GoRouter(routes: [
    GoRoute(
        path: "/",
        builder: (context, state) {
          return const ScreenLogic();
        }),
    GoRoute(
      path: '/registration',
      builder: (context, state) => const RegistrationScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/verifyEmail',
      builder: (context, state) => const VerifyEmailView(),
    ),
    GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: 'search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
              path: 'chat:groupDetails',
              builder: (context, state) =>
                  ChatScreen(groupDetails: state.params['groupDetails']),
              routes: [
                GoRoute(
                  path: 'groupInfo:groupDetail',
                  builder: (context, state) => GroupInfoScreen(
                    groupDetails: state.params["groupDetail"],
                  ),
                ),
              ]),
        ]),
  ]);
}
