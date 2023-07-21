import 'package:flutter/material.dart';
import 'package:quizzy/components/bottom-navigation.dart';
import 'package:quizzy/components/categories.dart';
import 'package:quizzy/components/header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(children: [
        Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(15.0, 20.0, 15, 0.0),
            child: const Text("Competitions Categories",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))),
        Expanded(child: Categories())
      ]),
      bottomNavigationBar: const BottomNav(),
    );
  }
}