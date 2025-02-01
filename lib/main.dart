import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/LoginActivity/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    title: "Tab Bar",
    home: WidgetTree(),
  ));
}
