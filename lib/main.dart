import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:quizzy/api_caller/firebase_api.dart';
import 'package:quizzy/provider/login_provider.dart';
import 'package:quizzy/provider/user_provider.dart';
import 'package:quizzy/routes/app_routes.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await Firebase.initializeApp(
  //   // Replace with actual values
  //   options: const FirebaseOptions(
  //     apiKey: "AIzaSyABkgsfsOSGcGNtt9CgQJQQKkYtlCLZ9yU",
  //     appId: "1:523404024585:android:1ca04e057b8cfffd6791d8",
  //     messagingSenderId: "523404024585",
  //     projectId: "quizzy-app-df051",
  //   ),
  // );
  // await FirebaseApi().initNotification();
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
