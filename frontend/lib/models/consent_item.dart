class ConsentItem {
  final String id;
  final String category;
  final String description;
  final bool isEnabled;
  final DateTime? grantedAt;
  final DateTime? expiryDate;
  final String scope;

  ConsentItem({
    required this.id,
    required this.category,
    required this.description,
    required this.isEnabled,
    this.grantedAt,
    this.expiryDate,
    this.scope = 'Marketing',
  });

  ConsentItem copyWith({
    String? id,
    String? category,
    String? description,
    bool? isEnabled,
    DateTime? grantedAt,
    DateTime? expiryDate,
    String? scope,
  }) {
    return ConsentItem(
      id: id ?? this.id,
      category: category ?? this.category,
      description: description ?? this.description,
      isEnabled: isEnabled ?? this.isEnabled,
      grantedAt: grantedAt ?? this.grantedAt,
      expiryDate: expiryDate ?? this.expiryDate,
      scope: scope ?? this.scope,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'description': description,
      'isEnabled': isEnabled,
      'grantedAt': grantedAt?.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'scope': scope,
    };
  }

  factory ConsentItem.fromJson(Map<String, dynamic> json) {
    return ConsentItem(
      id: json['id'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      isEnabled: json['isEnabled'] as bool,
      grantedAt: json['grantedAt'] != null
          ? DateTime.parse(json['grantedAt'] as String)
          : null,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      scope: json['scope'] as String? ?? 'Marketing',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConsentItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

