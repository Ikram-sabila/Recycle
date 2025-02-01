import 'package:project/LoginActivity/auth.dart';
import 'package:project/LoginActivity/login.dart';
import 'package:flutter/material.dart';
import 'package:project/dashboard.dart';
class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const Dashboard();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}