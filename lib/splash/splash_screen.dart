// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy/provider/login_provider.dart';
import 'package:quizzy/routes/app_routes.dart';
import 'package:quizzy/token/token_manager.dart';
import 'package:quizzy/token/user_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthProvider userProvider;
  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<AuthProvider>(context, listen: false);
    navigateToNextScreen(context);
  }

  Future<void> navigateToNextScreen(BuildContext context) async {
    String? authToken = await TokenManager.getToken();
    Map<String, dynamic> userData = await UserManager.getUserData();
    await Future.delayed(const Duration(milliseconds: 800));
    if (authToken != null) {
      userProvider.userDataFromShared(userData);
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
