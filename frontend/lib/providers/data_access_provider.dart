import 'package:flutter/foundation.dart';
import '../models/data_access_request.dart';

class DataAccessProvider extends ChangeNotifier {
  final List<DataAccessRequest> _requests = [];
  bool _isLoading = false;
  String? _error;
  String _selectedTab = 'All';

  List<DataAccessRequest> get requests => List.unmodifiable(_requests);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedTab => _selectedTab;

  List<DataAccessRequest> get filteredRequests {
    switch (_selectedTab) {
      case 'Pending':
        return _requests
            .where((r) => r.status == RequestStatus.pending)
            .toList();
      case 'Completed':
        return _requests
            .where((r) => r.status == RequestStatus.completed)
            .toList();
      default:
        return _requests;
    }
  }

  DataAccessProvider() {
    _initializeRequests();
  }

  void _initializeRequests() {
    _requests.addAll([
      DataAccessRequest(
        id: '1',
        title: 'Data Access Request #1',
        description: 'Request for personal data export',
        status: RequestStatus.pending,
        requestedAt: DateTime.now().subtract(const Duration(days: 1)),
        dataTypes: ['Email', 'Location'],
      ),
      DataAccessRequest(
        id: '2',
        title: 'Data Access Request #2',
        description: 'Request for account information',
        status: RequestStatus.approved,
        requestedAt: DateTime.now().subtract(const Duration(days: 3)),
        dataTypes: ['Profile', 'Preferences'],
      ),
      DataAccessRequest(
        id: '3',
        title: 'Data Access Request #3',
        description: 'Request for transaction history',
        status: RequestStatus.completed,
        requestedAt: DateTime.now().subtract(const Duration(days: 5)),
        completedAt: DateTime.now().subtract(const Duration(days: 2)),
        transactionHash: '0x1234567890abcdef',
        dataTypes: ['Financial Data'],
      ),
      DataAccessRequest(
        id: '4',
        title: 'Data Access Request #4',
        description: 'Request for analytics data',
        status: RequestStatus.pending,
        requestedAt: DateTime.now().subtract(const Duration(days: 7)),
        dataTypes: ['Analytics'],
      ),
      DataAccessRequest(
        id: '5',
        title: 'Data Access Request #5',
        description: 'Request for complete data export',
        status: RequestStatus.completed,
        requestedAt: DateTime.now().subtract(const Duration(days: 10)),
        completedAt: DateTime.now().subtract(const Duration(days: 8)),
        transactionHash: '0xabcdef1234567890',
        dataTypes: ['Email', 'Location', 'Analytics', 'Preferences'],
      ),
    ]);
  }

  void setSelectedTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  Future<void> addRequest({
    required String title,
    required String description,
    List<String> dataTypes = const [],
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final newRequest = DataAccessRequest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        status: RequestStatus.pending,
        requestedAt: DateTime.now(),
        dataTypes: dataTypes,
      );

      _requests.add(newRequest);
      notifyListeners();

      // Simulate blockchain transaction
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      _setError('Failed to add request: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateRequestStatus(
      String requestId, RequestStatus status) async {
    try {
      _setLoading(true);
      _clearError();

      final index = _requests.indexWhere((request) => request.id == requestId);
      if (index == -1) {
        throw Exception('Request not found');
      }

      final request = _requests[index];
      final updatedRequest = request.copyWith(
        status: status,
        completedAt: status == RequestStatus.completed
            ? DateTime.now()
            : request.completedAt,
        transactionHash: status == RequestStatus.completed
            ? '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}'
            : request.transactionHash,
      );

      _requests[index] = updatedRequest;
      notifyListeners();

      // Simulate blockchain transaction
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      _setError('Failed to update request: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteRequest(String requestId) async {
    try {
      _setLoading(true);
      _clearError();

      _requests.removeWhere((request) => request.id == requestId);
      notifyListeners();

      // Simulate blockchain transaction
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      _setError('Failed to delete request: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  DataAccessRequest? getRequestById(String id) {
    try {
      return _requests.firstWhere((request) => request.id == id);
    } catch (e) {
      return null;
    }
  }

  List<DataAccessRequest> getRequestsByStatus(RequestStatus status) {
    return _requests.where((request) => request.status == status).toList();
  }

  int get totalRequests => _requests.length;
  int get pendingRequests =>
      _requests.where((r) => r.status == RequestStatus.pending).length;
  int get completedRequests =>
      _requests.where((r) => r.status == RequestStatus.completed).length;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}

