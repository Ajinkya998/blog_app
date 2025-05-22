import 'package:blog_app/core/theme/theme.dart';
import 'package:blog_app/features/auth/presentation/pages/sign_in.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      title: 'Blog App',
      home: const SignInPage(),
    );
  }
}
