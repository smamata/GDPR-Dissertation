import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/top_app_bar.dart';

class ExportResultsScreen extends StatelessWidget {
  const ExportResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      appBar: TopAppBar(
        title: 'Export Results',
        showBackButton: true,
      ),
      body: Center(
        child: Text(
          'Export Results Screen\n(Implementation in progress)',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
      bottomNavigationBar: BottomNavigation(currentIndex: 3),
    );
  }
}
