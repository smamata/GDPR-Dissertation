import 'package:flutter/foundation.dart';
import '../models/wallet_state.dart';

class WalletProvider extends ChangeNotifier {
  WalletState _state = WalletState();

  WalletState get state => _state;
  bool get isConnected => _state.isConnected;
  String? get address => _state.address;
  String? get network => _state.network;
  bool get isConnecting => _state.isConnecting;
  String? get error => _state.error;

  Future<void> connectWallet(String walletType) async {
    try {
      _updateState(_state.copyWith(
        isConnecting: true,
        error: null,
      ));

      // Simulate wallet connection
      await Future.delayed(const Duration(seconds: 2));

      _updateState(_state.copyWith(
        isConnected: true,
        address: '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}',
        network: 'Ethereum Sepolia',
        isConnecting: false,
        error: null,
      ));
    } catch (e) {
      _updateState(_state.copyWith(
        isConnecting: false,
        error: 'Failed to connect wallet: ${e.toString()}',
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

  void _updateState(WalletState newState) {
    _state = newState;
    notifyListeners();
  }
}
