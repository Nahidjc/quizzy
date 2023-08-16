import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy/pages/home.dart';
import 'package:quizzy/pages/leaderboard.dart';
import 'package:quizzy/pages/login_page.dart';
import 'package:quizzy/pages/profile_page.dart';
import 'package:quizzy/pages/signup_page.dart';
import 'package:quizzy/provider/login_provider.dart';
import 'package:quizzy/widget/authenticate_checker.dart';

class AppRoutes {
  static const String splashscreen = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String leaderboard = '/leaderboard';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => AuthenticatedRoute(
          page: const Home(),
          isAuthenticated: Provider.of<AuthProvider>(context).isAuthenticated,
        ),
    login: (context) => const LoginPage(),
    register: (context) => const SignupPage(),
    profile: (context) => AuthenticatedRoute(
          page: const ProfilePage(),
          isAuthenticated: Provider.of<AuthProvider>(context).isAuthenticated,
        ),
    leaderboard: (context) => AuthenticatedRoute(
          page: const LeaderboardPage(),
          isAuthenticated: Provider.of<AuthProvider>(context).isAuthenticated,
        )
  };
}
