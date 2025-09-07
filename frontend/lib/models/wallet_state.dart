class WalletState {
  final bool isConnected;
  final String? address;
  final String? network;
  final String? connectedWalletType;
  final bool isConnecting;
  final String? connectingWalletType;
  final String? error;
  final Map<String, bool> walletConnectingStates;
  final Map<String, String?> walletErrors;

  WalletState({
    this.isConnected = false,
    this.address,
    this.network,
    this.connectedWalletType,
    this.isConnecting = false,
    this.connectingWalletType,
    this.error,
    this.walletConnectingStates = const {},
    this.walletErrors = const {},
  });

  WalletState copyWith({
    bool? isConnected,
    String? address,
    String? network,
    String? connectedWalletType,
    bool? isConnecting,
    String? connectingWalletType,
    String? error,
    Map<String, bool>? walletConnectingStates,
    Map<String, String?>? walletErrors,
  }) {
    return WalletState(
      isConnected: isConnected ?? this.isConnected,
      address: address ?? this.address,
      network: network ?? this.network,
      connectedWalletType: connectedWalletType ?? this.connectedWalletType,
      isConnecting: isConnecting ?? this.isConnecting,
      connectingWalletType: connectingWalletType ?? this.connectingWalletType,
      error: error ?? this.error,
      walletConnectingStates:
          walletConnectingStates ?? this.walletConnectingStates,
      walletErrors: walletErrors ?? this.walletErrors,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isConnected': isConnected,
      'address': address,
      'network': network,
      'connectedWalletType': connectedWalletType,
      'isConnecting': isConnecting,
      'connectingWalletType': connectingWalletType,
      'error': error,
      'walletConnectingStates': walletConnectingStates,
      'walletErrors': walletErrors,
    };
  }

  factory WalletState.fromJson(Map<String, dynamic> json) {
    return WalletState(
      isConnected: json['isConnected'] as bool? ?? false,
      address: json['address'] as String?,
      network: json['network'] as String?,
      connectedWalletType: json['connectedWalletType'] as String?,
      isConnecting: json['isConnecting'] as bool? ?? false,
      connectingWalletType: json['connectingWalletType'] as String?,
      error: json['error'] as String?,
      walletConnectingStates:
          Map<String, bool>.from(json['walletConnectingStates'] ?? {}),
      walletErrors: Map<String, String?>.from(json['walletErrors'] ?? {}),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WalletState &&
        other.isConnected == isConnected &&
        other.address == address &&
        other.network == network &&
        other.connectedWalletType == connectedWalletType &&
        other.isConnecting == isConnecting &&
        other.connectingWalletType == connectingWalletType &&
        other.error == error &&
        other.walletConnectingStates == walletConnectingStates &&
        other.walletErrors == walletErrors;
  }

  @override
  int get hashCode {
    return Object.hash(
      isConnected,
      address,
      network,
      connectedWalletType,
      isConnecting,
      connectingWalletType,
      error,
      walletConnectingStates,
      walletErrors,
    );
  }
}
