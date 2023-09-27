import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy/components/campaign/campaign_leaderboard.dart';
import 'package:quizzy/pages/leaderboard.dart';
import 'package:quizzy/pages/login_page.dart';
import 'package:quizzy/pages/update_user.dart';
import 'package:quizzy/provider/login_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context);
    if (!user.isAuthenticated) {
      return const LoginPage();
    }
    ImageProvider<Object>? backgroundImage;
    if (user.profileUrl == null) {
      backgroundImage = const AssetImage("assets/images/avatar.png");
    } else {
      backgroundImage = NetworkImage(user.profileUrl!);
    }
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 144, 106, 250),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundImage: backgroundImage,
                      ),
                      Text(
                        user.name,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      // const  Text(
                      //   'test@email.com',
                      //   style: TextStyle(color: Colors.white, fontSize: 12),
                      // ),
                    ],
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.edit_rounded),
                    title: const Text('Update Profile'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            UserProfilePage(userId: user.userId),
                      ));
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.add_chart),
                    title: const Text('Statistics'),
                    onTap: () {
                      // Handle the drawer item tap here
                      Navigator.pop(context);
                      // Implement your logic here
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.currency_exchange),
                    title: const Text('Coin Transfer'),
                    onTap: () {
                      //  Navigator.pop(context);
                      Navigator.of(context)
                          .popAndPushNamed("/cointransferpage");
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.history_edu),
                    title: const Text('Quiz History'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.leaderboard),
                    title: const Text('Leader Board'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LeaderboardPage(),
                      ));
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.leaderboard),
                    title: const Text('Campaign Leaderboard'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CampaignLeaderboardPage(),
                      ));
                    },
                  ),
                ),
              ],
            ),
          ),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: const Text(
                'Logout',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                if (user.isAuthenticated) {
                  user.logout();
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Version: 1.0.0',
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
