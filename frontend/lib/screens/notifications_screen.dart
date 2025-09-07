import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/top_app_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      appBar: TopAppBar(
        title: 'Notifications',
        showBackButton: true,
      ),
      body: Center(
        child: Text(
          'Notifications Screen\n(Implementation in progress)',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
      bottomNavigationBar: BottomNavigation(currentIndex: 0),
    );
  }
}
