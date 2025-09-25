enum DeletionStatus {
  pending,
  approved,
  processing,
  completed,
  rejected,
}

class DeletionRequest {
  final String id;
  final String title;
  final String description;
  final DeletionStatus status;
  final DateTime requestedAt;
  final DateTime? completedAt;
  final String? transactionHash;
  final List<String> dataTypes;
  final String? reason;
  final String? rejectionReason;

  DeletionRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.requestedAt,
    this.completedAt,
    this.transactionHash,
    this.dataTypes = const [],
    this.reason,
    this.rejectionReason,
  });

  DeletionRequest copyWith({
    String? id,
    String? title,
    String? description,
    DeletionStatus? status,
    DateTime? requestedAt,
    DateTime? completedAt,
    String? transactionHash,
    List<String>? dataTypes,
    String? reason,
    String? rejectionReason,
  }) {
    return DeletionRequest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
      completedAt: completedAt ?? this.completedAt,
      transactionHash: transactionHash ?? this.transactionHash,
      dataTypes: dataTypes ?? this.dataTypes,
      reason: reason ?? this.reason,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'requestedAt': requestedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'transactionHash': transactionHash,
      'dataTypes': dataTypes,
      'reason': reason,
      'rejectionReason': rejectionReason,
    };
  }

  factory DeletionRequest.fromJson(Map<String, dynamic> json) {
    return DeletionRequest(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: DeletionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DeletionStatus.pending,
      ),
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      transactionHash: json['transactionHash'] as String?,
      dataTypes: List<String>.from(json['dataTypes'] as List? ?? []),
      reason: json['reason'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeletionRequest && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
