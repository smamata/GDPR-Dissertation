import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/top_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      appBar: TopAppBar(
        title: 'Settings',
        showBackButton: true,
      ),
      body: Center(
        child: Text(
          'Settings Screen\n(Implementation in progress)',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
      bottomNavigationBar: BottomNavigation(currentIndex: 3),
    );
  }
}
