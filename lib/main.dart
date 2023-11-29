import 'package:flutter/material.dart';
import 'package:saheli/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Saheli',
      theme: ThemeData.dark(useMaterial3: true).copyWith(scaffoldBackgroundColor: Colors.black,appBarTheme: const AppBarTheme(backgroundColor: Colors.grey)),
      home: const HomePage(),
    );
  }
}

