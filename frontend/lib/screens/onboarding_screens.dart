import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';

class OnboardingScreens extends StatelessWidget {
  const OnboardingScreens({super.key});

  static final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Smart GDPR\nCompliance',
      subtitle: 'Blockchain-powered consent management\nfor the modern web',
      icon: Icons.security,
      color: const Color(0xFF4CAF50),
    ),
    OnboardingData(
      title: 'Gas-Efficient\nOperations',
      subtitle: 'Optimized smart contracts that\nminimize transaction costs',
      icon: Icons.speed,
      color: const Color(0xFF2196F3),
    ),
    OnboardingData(
      title: 'Real-time\nAnalytics',
      subtitle: 'Track performance and costs\nacross multiple networks',
      icon: Icons.analytics,
      color: const Color(0xFFFF9800),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(
      builder: (context, onboardingProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF1A1A2E),
          body: SafeArea(
            child: Column(
              children: [
                // Skip button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => context.go('/connect-wallet'),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Page view
                Expanded(
                  child: PageView.builder(
                    controller: onboardingProvider.pageController,
                    onPageChanged: (index) {
                      onboardingProvider.setCurrentPage(index);
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return _buildPage(_pages[index]);
                    },
                  ),
                ),

                // Page indicators
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: onboardingProvider.currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: onboardingProvider.currentPage == index
                              ? _pages[index].color
                              : Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),

                // Navigation buttons
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (onboardingProvider.currentPage > 0)
                        TextButton(
                          onPressed: () {
                            onboardingProvider.previousPage();
                          },
                          child: const Text(
                            'Back',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 60),
                      ElevatedButton(
                        onPressed: () {
                          if (onboardingProvider.currentPage <
                              _pages.length - 1) {
                            onboardingProvider.nextPage();
                          } else {
                            context.go('/connect-wallet');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _pages[onboardingProvider.currentPage].color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          onboardingProvider.currentPage < _pages.length - 1
                              ? 'Next'
                              : 'Get Started',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              data.icon,
              size: 100,
              color: data.color,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            data.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            data.subtitle,
            style: const TextStyle(
              color: Color(0xFFB0B0B0),
              fontSize: 18,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
