import 'package:flutter/material.dart';
import 'package:quizzy/pages/login_page.dart';

class AuthenticatedRoute extends StatelessWidget {
  final Widget page;
  final bool isAuthenticated;

  const AuthenticatedRoute({
    super.key, 
    required this.page,
    required this.isAuthenticated,
  });

  @override
  Widget build(BuildContext context) {
    if (isAuthenticated) {
      return page;
    } else {
      return const LoginPage();
    }
  }
}
