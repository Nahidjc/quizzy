import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy/components/custom_drawer.dart';
import 'package:quizzy/pages/leaderboard.dart';
import 'package:quizzy/pages/login_page.dart';
import 'package:quizzy/provider/login_provider.dart';
import 'package:quizzy/routes/app_routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthProvider user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context);

    if (!user.isAuthenticated) {
      return const LoginPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Profile',
          style: TextStyle(color: Colors.white),
        ),
        toolbarHeight: 120.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to the previous page
          },
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.home);
              }),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Score: ${user.coin}',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        if (user.isAuthenticated) {
                          user.logout();
                          Navigator.popUntil(context, (route) => route.isFirst);
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Logout',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LeaderboardPage(),
                        ));
                      },
                      icon: const Icon(Icons.leaderboard),
                      label: const Text(
                        'Leaderboard',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ])
                ],
              ),
            ),
            Positioned(
              top: kToolbarHeight + 0.0,
              left: MediaQuery.of(context).size.width / 2 - 80,
              child: const CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage("assets/images/avatar.png"),
              ),
            ),
          ],
        ),
      ),
      endDrawer: const CustomDrawer(),
    );
  }
}
