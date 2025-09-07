import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';

class ConnectWalletScreen extends StatefulWidget {
  const ConnectWalletScreen({super.key});

  @override
  State<ConnectWalletScreen> createState() => _ConnectWalletScreenState();
}

class _ConnectWalletScreenState extends State<ConnectWalletScreen> {
  @override
  void initState() {
    super.initState();
    // Clear any previous errors when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final walletProvider =
          Provider.of<WalletProvider>(context, listen: false);
      walletProvider.clearAllWalletErrors();
    });
  }

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
            actions: [
              // Clear all errors button for testing
              if (walletProvider.error != null ||
                  walletProvider.getWalletError('MetaMask') != null ||
                  walletProvider.getWalletError('WalletConnect') != null ||
                  walletProvider.getWalletError('Coinbase') != null)
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () {
                    walletProvider.clearAllWalletErrors();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All errors cleared'),
                        backgroundColor: Color(0xFF4CAF50),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      48,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Header - Made more compact
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF16213E), Color(0xFF0F3460)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Connect Your Wallet',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),

                      const Text(
                        'Connect your wallet to start managing GDPR compliance on the blockchain',
                        style: TextStyle(
                          color: Color(0xFFB0B0B0),
                          fontSize: 14,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Global error display
                      if (walletProvider.error != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline,
                                  color: Colors.red, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  walletProvider.error!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                              IconButton(
                                onPressed: () => walletProvider.clearError(),
                                icon: const Icon(Icons.close,
                                    color: Colors.red, size: 18),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                    minWidth: 24, minHeight: 24),
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
                      const SizedBox(height: 12),

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
                      const SizedBox(height: 12),

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
                      const Padding(
                        padding: EdgeInsets.only(top: 24, bottom: 16),
                        child: Text(
                          'By connecting your wallet, you agree to our Terms of Service and Privacy Policy',
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 11,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: error != null
                  ? Colors.red.withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: isConnecting ? null : onTap,
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: error != null
                        ? Colors.red.withOpacity(0.1)
                        : const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon,
                      color:
                          error != null ? Colors.red : const Color(0xFF4CAF50),
                      size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: error != null ? Colors.red : Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFFB0B0B0),
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (isConnecting)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                    ),
                  )
                else if (error != null)
                  IconButton(
                    onPressed: onClearError,
                    icon: const Icon(Icons.close, color: Colors.red, size: 18),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 24, minHeight: 24),
                  )
                else
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFB0B0B0),
                    size: 14,
                  ),
              ],
            ),
          ),
        ),
        // Individual wallet error display - Made more compact
        if (error != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 11),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: onClearError,
                  icon: const Icon(Icons.close, color: Colors.red, size: 14),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 20, minHeight: 20),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _connectWallet(BuildContext context, String walletType) async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    // Prevent multiple rapid taps on the same wallet
    if (walletProvider.isWalletConnecting(walletType)) {
      print('$walletType is already connecting, ignoring tap');
      return;
    }

    // Prevent connection if any wallet is already connected
    if (walletProvider.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Wallet ${walletProvider.connectedWalletType} is already connected'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    try {
      print('Attempting to connect $walletType');
      await walletProvider.connectWallet(walletType);

      // Check if connection was successful
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
            duration: const Duration(seconds: 2),
          ),
        );

        // Small delay before navigation to show the success message
        await Future.delayed(const Duration(milliseconds: 500));

        // Navigate to home
        if (context.mounted) {
          context.go('/home');
        }
      }
    } catch (e) {
      // Error handling is already done in the provider
      // The UI will automatically show the error state
      print('Connection error for $walletType: $e');

      // Show error toast as well
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect $walletType'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
