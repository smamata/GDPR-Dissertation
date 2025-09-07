import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';

class ConnectWalletScreen extends StatelessWidget {
  const ConnectWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (context, walletProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF1A1A2E),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.go('/onboarding'),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Header
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF16213E), Color(0xFF0F3460)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'Connect Your Wallet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Connect your wallet to start managing GDPR compliance\non the blockchain',
                    style: TextStyle(
                      color: Color(0xFFB0B0B0),
                      fontSize: 16,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Global error display
                  if (walletProvider.error != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              walletProvider.error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                          IconButton(
                            onPressed: () => walletProvider.clearError(),
                            icon: const Icon(Icons.close, color: Colors.red),
                          ),
                        ],
                      ),
                    ),

                  // Wallet options
                  _buildWalletOption(
                    context,
                    'MetaMask',
                    'Connect using MetaMask browser extension',
                    Icons.account_balance_wallet,
                    () => _connectWallet(context, 'MetaMask'),
                    walletProvider.isWalletConnecting('MetaMask'),
                    walletProvider.getWalletError('MetaMask'),
                    () => walletProvider.clearWalletError('MetaMask'),
                  ),
                  const SizedBox(height: 16),

                  _buildWalletOption(
                    context,
                    'WalletConnect',
                    'Connect using WalletConnect protocol',
                    Icons.wifi,
                    () => _connectWallet(context, 'WalletConnect'),
                    walletProvider.isWalletConnecting('WalletConnect'),
                    walletProvider.getWalletError('WalletConnect'),
                    () => walletProvider.clearWalletError('WalletConnect'),
                  ),
                  const SizedBox(height: 16),

                  _buildWalletOption(
                    context,
                    'Coinbase Wallet',
                    'Connect using Coinbase Wallet',
                    Icons.account_balance,
                    () => _connectWallet(context, 'Coinbase'),
                    walletProvider.isWalletConnecting('Coinbase'),
                    walletProvider.getWalletError('Coinbase'),
                    () => walletProvider.clearWalletError('Coinbase'),
                  ),

                  const Spacer(),

                  // Terms and privacy
                  const Text(
                    'By connecting your wallet, you agree to our Terms of Service\nand Privacy Policy',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 12,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWalletOption(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      VoidCallback onTap,
      bool isConnecting,
      String? error,
      VoidCallback? onClearError) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: error != null
                  ? Colors.red.withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: isConnecting ? null : onTap,
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: error != null
                        ? Colors.red.withOpacity(0.1)
                        : const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon,
                      color:
                          error != null ? Colors.red : const Color(0xFF4CAF50),
                      size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: error != null ? Colors.red : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFFB0B0B0),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isConnecting)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                    ),
                  )
                else if (error != null)
                  IconButton(
                    onPressed: onClearError,
                    icon: const Icon(Icons.close, color: Colors.red, size: 20),
                  )
                else
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFB0B0B0),
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
        // Individual wallet error display
        if (error != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
                IconButton(
                  onPressed: onClearError,
                  icon: const Icon(Icons.close, color: Colors.red, size: 16),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 24, minHeight: 24),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _connectWallet(BuildContext context, String walletType) async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    try {
      await walletProvider.connectWallet(walletType);

      if (walletProvider.isConnected &&
          walletProvider.connectedWalletType == walletType) {
        // Show success toast
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$walletType connected on ${walletProvider.network}'),
            backgroundColor: const Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

        // Navigate to home
        context.go('/home');
      }
    } catch (e) {
      // Error handling is already done in the provider
      // The UI will automatically show the error state
      print('Connection error for $walletType: $e');
    }
  }
}
