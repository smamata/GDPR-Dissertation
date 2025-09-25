import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/top_app_bar.dart';
import '../providers/consent_provider.dart';
import '../models/consent_item.dart';

class ConsentManagementScreen extends StatelessWidget {
  const ConsentManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: const TopAppBar(
        title: 'Consent Management',
        showBackButton: true,
      ),
      body: Consumer<ConsentProvider>(
        builder: (context, consentProvider, child) {
          if (consentProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              ),
            );
          }

          if (consentProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${consentProvider.error}',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => consentProvider.clearError(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Manage your data consent preferences',
                        style: TextStyle(
                          color: Color(0xFFB0B0B0),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Grant new consent button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => context.go('/new-consent'),
                          icon: const Icon(Icons.add, size: 20),
                          label: const Text('Grant New Consent'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Consents list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: consentProvider.consents.length,
                    itemBuilder: (context, index) {
                      return _buildConsentItem(
                          context, consentProvider.consents[index]);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 0),
    );
  }

  Widget _buildConsentItem(BuildContext context, ConsentItem consent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: consent.isEnabled
              ? const Color(0xFF4CAF50).withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color:
                    consent.isEnabled ? const Color(0xFF4CAF50) : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  consent.category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch(
                value: consent.isEnabled,
                onChanged: (value) => _toggleConsent(context, consent, value),
                activeColor: const Color(0xFF4CAF50),
                inactiveThumbColor: Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            consent.description,
            style: const TextStyle(
              color: Color(0xFFB0B0B0),
              fontSize: 14,
            ),
          ),
          if (consent.grantedAt != null) ...[
            const SizedBox(height: 8),
            Text(
              'Granted: ${_formatDate(consent.grantedAt!)}',
              style: const TextStyle(
                color: Color(0xFF666666),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _toggleConsent(BuildContext context, ConsentItem consent, bool value) {
    final consentProvider =
        Provider.of<ConsentProvider>(context, listen: false);

    if (!value && consent.isEnabled) {
      // Show confirmation dialog for revoking consent
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF16213E),
          title: const Text(
            'Revoke Consent?',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to revoke consent for ${consent.category}?',
            style: const TextStyle(color: Color(0xFFB0B0B0)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                consentProvider.toggleConsent(consent.id, false);
                _showToast(context, 'Consent revoked for ${consent.category}');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53E3E),
                foregroundColor: Colors.white,
              ),
              child: const Text('Revoke'),
            ),
          ],
        ),
      );
    } else {
      consentProvider.toggleConsent(consent.id, value);
      if (value) {
        _showToast(context, 'Consent granted for ${consent.category}');
      }
    }
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
