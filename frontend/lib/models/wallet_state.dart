class WalletState {
  final bool isConnected;
  final String? address;
  final String? network;
  final bool isConnecting;
  final String? error;

  WalletState({
    this.isConnected = false,
    this.address,
    this.network,
    this.isConnecting = false,
    this.error,
  });

  WalletState copyWith({
    bool? isConnected,
    String? address,
    String? network,
    bool? isConnecting,
    String? error,
  }) {
    return WalletState(
      isConnected: isConnected ?? this.isConnected,
      address: address ?? this.address,
      network: network ?? this.network,
      isConnecting: isConnecting ?? this.isConnecting,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isConnected': isConnected,
      'address': address,
      'network': network,
      'isConnecting': isConnecting,
      'error': error,
    };
  }

  factory WalletState.fromJson(Map<String, dynamic> json) {
    return WalletState(
      isConnected: json['isConnected'] as bool? ?? false,
      address: json['address'] as String?,
      network: json['network'] as String?,
      isConnecting: json['isConnecting'] as bool? ?? false,
      error: json['error'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WalletState &&
        other.isConnected == isConnected &&
        other.address == address &&
        other.network == network &&
        other.isConnecting == isConnecting &&
        other.error == error;
  }

  @override
  int get hashCode {
    return Object.hash(
      isConnected,
      address,
      network,
      isConnecting,
      error,
    );
  }
}

