enum RequestStatus {
  pending,
  approved,
  completed,
  rejected,
}

class DataAccessRequest {
  final String id;
  final String title;
  final String description;
  final RequestStatus status;
  final DateTime requestedAt;
  final DateTime? completedAt;
  final String? transactionHash;
  final List<String> dataTypes;

  DataAccessRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.requestedAt,
    this.completedAt,
    this.transactionHash,
    this.dataTypes = const [],
  });

  DataAccessRequest copyWith({
    String? id,
    String? title,
    String? description,
    RequestStatus? status,
    DateTime? requestedAt,
    DateTime? completedAt,
    String? transactionHash,
    List<String>? dataTypes,
  }) {
    return DataAccessRequest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
      completedAt: completedAt ?? this.completedAt,
      transactionHash: transactionHash ?? this.transactionHash,
      dataTypes: dataTypes ?? this.dataTypes,
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
    };
  }

  factory DataAccessRequest.fromJson(Map<String, dynamic> json) {
    return DataAccessRequest(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: RequestStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => RequestStatus.pending,
      ),
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      transactionHash: json['transactionHash'] as String?,
      dataTypes: List<String>.from(json['dataTypes'] as List? ?? []),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DataAccessRequest && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

