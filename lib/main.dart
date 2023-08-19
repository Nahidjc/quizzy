import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy/provider/login_provider.dart';
import 'package:quizzy/provider/user_provider.dart';
import 'package:quizzy/routes/app_routes.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
    MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      testDeviceIds: ["04EEFC819D7EC0BC2C8AA4FF808933B1"],
    ),
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splashscreen,
      routes: AppRoutes.routes,
    );
  }
}
