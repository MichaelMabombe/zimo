import 'package:flutter/material.dart';
import '../features/auth/presentation/login_page.dart';

class ZimoApp extends StatelessWidget {
  const ZimoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
