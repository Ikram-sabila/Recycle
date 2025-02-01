import 'package:flutter/material.dart';
import 'package:project/HomeActivity/home.dart' as home_page;
import 'package:project/ProfileActivity/profile.dart' as profile_page;
import 'package:project/ChatActivity/chat.dart' as chat_page;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _HomeState();
}

class _HomeState extends State<Dashboard> with SingleTickerProviderStateMixin {
  late TabController controller;

  final _selectedColor = Color(0xFF42b29e);

  @override
  void initState() {
    controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller,
        children:  <Widget>[
          new home_page.Home(),
          new chat_page.Chat(),
          new profile_page.Profile(),
        ],
      ),
      bottomNavigationBar: Material(
        color: Colors.white,
        child: TabBar(
          labelPadding: const EdgeInsets.symmetric(vertical: 5.0),
          controller: controller,
          unselectedLabelColor: Colors.grey[600],
          labelColor: _selectedColor,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(80.0),
            color: _selectedColor.withOpacity(0.2),
          ),
          indicatorPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: -25),
          tabs: const <Widget>[
            Tab(icon: Icon(Icons.home, size: 35.0)),
            Tab(icon: Icon(Icons.scanner, size: 35.0)),
            Tab(icon: Icon(Icons.person, size: 35.0)),
          ],
        ),
      ),
    );
  }
}
