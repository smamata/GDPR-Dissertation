import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screens.dart';
import 'screens/connect_wallet_screen.dart';
import 'screens/home_dashboard_screen.dart';
import 'screens/consent_management_screen.dart';
import 'screens/new_consent_screen.dart';
import 'screens/data_access_requests_screen.dart';
import 'screens/new_data_access_request_screen.dart';
import 'screens/deletion_requests_screen.dart';
import 'screens/delete_confirmation_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/smart_contract_library_screen.dart';
import 'screens/deploy_test_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/network_picker_screen.dart';
import 'screens/export_results_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/transaction_detail_screen.dart';
import 'widgets/app_theme.dart';
import 'providers/consent_provider.dart';
import 'providers/wallet_provider.dart';
import 'providers/data_access_provider.dart';
import 'providers/onboarding_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConsentProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => DataAccessProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
      ],
      child: MaterialApp.router(
        title: 'GDPR Chain Prototype',
        theme: AppTheme.darkTheme,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    // S0 - Splash Screen
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // S1-S3 - Onboarding
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreens(),
    ),

    // S4 - Connect Wallet
    GoRoute(
      path: '/connect-wallet',
      builder: (context, state) => const ConnectWalletScreen(),
    ),

    // S5 - Home Dashboard
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeDashboardScreen(),
    ),

    // S6 - Consent Management
    GoRoute(
      path: '/consent-management',
      builder: (context, state) => const ConsentManagementScreen(),
    ),

    // S7 - New Consent
    GoRoute(
      path: '/new-consent',
      builder: (context, state) => const NewConsentScreen(),
    ),

    // S8 - Data Access Requests
    GoRoute(
      path: '/data-access-requests',
      builder: (context, state) => const DataAccessRequestsScreen(),
    ),

    // S9 - New Data Access Request
    GoRoute(
      path: '/new-data-access-request',
      builder: (context, state) => const NewDataAccessRequestScreen(),
    ),

    // S10 - Deletion Requests
    GoRoute(
      path: '/deletion-requests',
      builder: (context, state) => const DeletionRequestsScreen(),
    ),

    // S11 - Delete Confirmation
    GoRoute(
      path: '/delete-confirmation',
      builder: (context, state) => const DeleteConfirmationScreen(),
    ),

    // S12 - Analytics
    GoRoute(
      path: '/analytics',
      builder: (context, state) => const AnalyticsScreen(),
    ),

    // S13 - Smart Contract Library
    GoRoute(
      path: '/smart-contract-library',
      builder: (context, state) => const SmartContractLibraryScreen(),
    ),

    // S14 - Deploy Test
    GoRoute(
      path: '/deploy-test',
      builder: (context, state) => const DeployTestScreen(),
    ),

    // S15 - Settings
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),

    // S16 - Network Picker
    GoRoute(
      path: '/network-picker',
      builder: (context, state) => const NetworkPickerScreen(),
    ),

    // S17 - Export Results
    GoRoute(
      path: '/export-results',
      builder: (context, state) => const ExportResultsScreen(),
    ),

    // S18 - Notifications
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),

    // S19 - Transaction Detail
    GoRoute(
      path: '/transaction-detail',
      builder: (context, state) => const TransactionDetailScreen(),
    ),
  ],
);
