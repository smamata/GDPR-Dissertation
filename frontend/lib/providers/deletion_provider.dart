import 'package:flutter/foundation.dart';
import '../models/deletion_request.dart';

class DeletionProvider extends ChangeNotifier {
  final List<DeletionRequest> _requests = [];
  bool _isLoading = false;
  String? _error;
  String _selectedTab = 'All';

  List<DeletionRequest> get requests => List.unmodifiable(_requests);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedTab => _selectedTab;

  List<DeletionRequest> get filteredRequests {
    switch (_selectedTab) {
      case 'Pending':
        return _requests
            .where((r) => r.status == DeletionStatus.pending)
            .toList();
      case 'Processing':
        return _requests
            .where((r) => r.status == DeletionStatus.processing)
            .toList();
      case 'Completed':
        return _requests
            .where((r) => r.status == DeletionStatus.completed)
            .toList();
      case 'Rejected':
        return _requests
            .where((r) => r.status == DeletionStatus.rejected)
            .toList();
      default:
        return _requests;
    }
  }

  DeletionProvider() {
    _initializeRequests();
  }

  void _initializeRequests() {
    _requests.addAll([
      DeletionRequest(
        id: '1',
        title: 'Account Deletion Request',
        description: 'Complete removal of user account and all associated data',
        status: DeletionStatus.pending,
        requestedAt: DateTime.now().subtract(const Duration(days: 1)),
        dataTypes: ['Profile', 'Email', 'Preferences'],
        reason: 'User requested complete account deletion',
      ),
      DeletionRequest(
        id: '2',
        title: 'Data Deletion Request #2',
        description: 'Remove specific data categories from user profile',
        status: DeletionStatus.approved,
        requestedAt: DateTime.now().subtract(const Duration(days: 3)),
        dataTypes: ['Location History', 'Analytics'],
        reason: 'User wants to remove location tracking data',
      ),
      DeletionRequest(
        id: '3',
        title: 'Data Deletion Request #3',
        description: 'Delete financial transaction history',
        status: DeletionStatus.processing,
        requestedAt: DateTime.now().subtract(const Duration(days: 5)),
        dataTypes: ['Financial Data', 'Transaction History'],
        reason: 'Privacy concerns regarding financial data',
      ),
      DeletionRequest(
        id: '4',
        title: 'Data Deletion Request #4',
        description: 'Remove all marketing and communication data',
        status: DeletionStatus.completed,
        requestedAt: DateTime.now().subtract(const Duration(days: 7)),
        completedAt: DateTime.now().subtract(const Duration(days: 2)),
        transactionHash: '0x1234567890abcdef',
        dataTypes: ['Marketing Data', 'Communication History'],
        reason: 'User opted out of all marketing communications',
      ),
      DeletionRequest(
        id: '5',
        title: 'Data Deletion Request #5',
        description: 'Delete social media integration data',
        status: DeletionStatus.rejected,
        requestedAt: DateTime.now().subtract(const Duration(days: 10)),
        dataTypes: ['Social Media Data'],
        reason: 'User wants to remove social media connections',
        rejectionReason: 'Data required for legal compliance',
      ),
      DeletionRequest(
        id: '6',
        title: 'Complete Data Deletion',
        description: 'Full account and data deletion request',
        status: DeletionStatus.pending,
        requestedAt: DateTime.now().subtract(const Duration(days: 2)),
        dataTypes: ['All Data Types'],
        reason: 'User requested complete data removal',
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
    required String reason,
    List<String> dataTypes = const [],
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final newRequest = DeletionRequest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        status: DeletionStatus.pending,
        requestedAt: DateTime.now(),
        dataTypes: dataTypes,
        reason: reason,
      );

      _requests.add(newRequest);
      notifyListeners();

      // Simulate blockchain transaction
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      _setError('Failed to add deletion request: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateRequestStatus(String requestId, DeletionStatus status,
      {String? rejectionReason}) async {
    try {
      _setLoading(true);
      _clearError();

      final index = _requests.indexWhere((request) => request.id == requestId);
      if (index == -1) {
        throw Exception('Deletion request not found');
      }

      final request = _requests[index];
      final updatedRequest = request.copyWith(
        status: status,
        completedAt: status == DeletionStatus.completed
            ? DateTime.now()
            : request.completedAt,
        transactionHash: status == DeletionStatus.completed
            ? '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}'
            : request.transactionHash,
        rejectionReason: rejectionReason,
      );

      _requests[index] = updatedRequest;
      notifyListeners();

      // Simulate blockchain transaction
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      _setError('Failed to update deletion request: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> approveRequest(String requestId) async {
    await updateRequestStatus(requestId, DeletionStatus.approved);
  }

  Future<void> startProcessing(String requestId) async {
    await updateRequestStatus(requestId, DeletionStatus.processing);
  }

  Future<void> completeRequest(String requestId) async {
    await updateRequestStatus(requestId, DeletionStatus.completed);
  }

  Future<void> rejectRequest(String requestId, String rejectionReason) async {
    await updateRequestStatus(requestId, DeletionStatus.rejected,
        rejectionReason: rejectionReason);
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

  DeletionRequest? getRequestById(String id) {
    try {
      return _requests.firstWhere((request) => request.id == id);
    } catch (e) {
      return null;
    }
  }

  List<DeletionRequest> getRequestsByStatus(DeletionStatus status) {
    return _requests.where((request) => request.status == status).toList();
  }

  int get totalRequests => _requests.length;
  int get pendingRequests =>
      _requests.where((r) => r.status == DeletionStatus.pending).length;
  int get processingRequests =>
      _requests.where((r) => r.status == DeletionStatus.processing).length;
  int get completedRequests =>
      _requests.where((r) => r.status == DeletionStatus.completed).length;
  int get rejectedRequests =>
      _requests.where((r) => r.status == DeletionStatus.rejected).length;

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
