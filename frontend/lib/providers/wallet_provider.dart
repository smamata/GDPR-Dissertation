import 'package:flutter/foundation.dart';
import '../models/wallet_state.dart';

class WalletProvider extends ChangeNotifier {
  WalletState _state = WalletState();

  WalletState get state => _state;
  bool get isConnected => _state.isConnected;
  String? get address => _state.address;
  String? get network => _state.network;
  String? get connectedWalletType => _state.connectedWalletType;
  bool get isConnecting => _state.isConnecting;
  String? get connectingWalletType => _state.connectingWalletType;
  String? get error => _state.error;

  // Individual wallet state getters
  bool isWalletConnecting(String walletType) =>
      _state.walletConnectingStates[walletType] ?? false;
  String? getWalletError(String walletType) => _state.walletErrors[walletType];

  Future<void> connectWallet(String walletType) async {
    // Prevent multiple simultaneous connections
    if (_state.isConnecting) {
      print(
          'Connection already in progress for ${_state.connectingWalletType}');
      return;
    }

    // Check if this specific wallet is already connecting
    if (_state.walletConnectingStates[walletType] == true) {
      print('$walletType is already connecting');
      return;
    }

    try {
      // Clear any previous errors for this wallet and global errors
      final updatedWalletErrors =
          Map<String, String?>.from(_state.walletErrors);
      updatedWalletErrors[walletType] = null;

      // Set connecting state for this specific wallet
      final updatedConnectingStates =
          Map<String, bool>.from(_state.walletConnectingStates);
      updatedConnectingStates[walletType] = true;

      _updateState(_state.copyWith(
        isConnecting: true,
        connectingWalletType: walletType,
        error: null, // Clear global error
        walletConnectingStates: updatedConnectingStates,
        walletErrors: updatedWalletErrors,
      ));

      print('Starting connection for $walletType');

      // Simulate different connection times for different wallets
      int connectionDelay;
      switch (walletType.toLowerCase()) {
        case 'metamask':
          connectionDelay = 2;
          break;
        case 'walletconnect':
          connectionDelay = 3;
          break;
        case 'coinbase':
          connectionDelay = 2;
          break;
        default:
          connectionDelay = 2;
      }

      await Future.delayed(Duration(seconds: connectionDelay));

      // Simulate occasional connection failures for testing (disabled for production)
      // Uncomment the lines below if you want to test error handling
      /*
      if (walletType.toLowerCase() == 'walletconnect' &&
          DateTime.now().millisecond % 3 == 0) {
        throw Exception('WalletConnect connection failed. Please try again.');
      }
      */

      print('Successfully connected $walletType');

      // Clear connecting state for this wallet
      final finalConnectingStates =
          Map<String, bool>.from(_state.walletConnectingStates);
      finalConnectingStates[walletType] = false;

      _updateState(_state.copyWith(
        isConnected: true,
        address: '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}',
        network: 'Ethereum Sepolia',
        connectedWalletType: walletType,
        isConnecting: false,
        connectingWalletType: null,
        error: null,
        walletConnectingStates: finalConnectingStates,
      ));
    } catch (e) {
      print('Connection failed for $walletType: $e');

      // Set error for this specific wallet only
      final updatedWalletErrors =
          Map<String, String?>.from(_state.walletErrors);
      updatedWalletErrors[walletType] = e.toString();

      // Clear connecting state for this wallet
      final finalConnectingStates =
          Map<String, bool>.from(_state.walletConnectingStates);
      finalConnectingStates[walletType] = false;

      _updateState(_state.copyWith(
        isConnecting: false,
        connectingWalletType: null,
        error: null, // Don't set global error, use individual wallet errors
        walletConnectingStates: finalConnectingStates,
        walletErrors: updatedWalletErrors,
      ));
    }
  }

  Future<void> disconnectWallet() async {
    try {
      _updateState(_state.copyWith(
        isConnecting: true,
        error: null,
      ));

      // Simulate wallet disconnection
      await Future.delayed(const Duration(seconds: 1));

      _updateState(WalletState());
    } catch (e) {
      _updateState(_state.copyWith(
        isConnecting: false,
        error: 'Failed to disconnect wallet: ${e.toString()}',
      ));
    }
  }

  Future<void> switchNetwork(String network) async {
    try {
      _updateState(_state.copyWith(
        isConnecting: true,
        error: null,
      ));

      // Simulate network switch
      await Future.delayed(const Duration(seconds: 1));

      _updateState(_state.copyWith(
        network: network,
        isConnecting: false,
        error: null,
      ));
    } catch (e) {
      _updateState(_state.copyWith(
        isConnecting: false,
        error: 'Failed to switch network: ${e.toString()}',
      ));
    }
  }

  void clearError() {
    _updateState(_state.copyWith(error: null));
  }

  void clearWalletError(String walletType) {
    final updatedWalletErrors = Map<String, String?>.from(_state.walletErrors);
    updatedWalletErrors[walletType] = null;
    _updateState(_state.copyWith(walletErrors: updatedWalletErrors));
  }

  void clearAllWalletStates() {
    _updateState(WalletState());
  }

  void clearAllWalletErrors() {
    _updateState(_state.copyWith(
      error: null,
      walletErrors: {},
    ));
  }

  void _updateState(WalletState newState) {
    _state = newState;
    notifyListeners();
  }
}
