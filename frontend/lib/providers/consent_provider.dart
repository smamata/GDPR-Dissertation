import 'package:flutter/foundation.dart';
import '../models/consent_item.dart';

class ConsentProvider extends ChangeNotifier {
  final List<ConsentItem> _consents = [];
  bool _isLoading = false;
  String? _error;

  List<ConsentItem> get consents => List.unmodifiable(_consents);
  bool get isLoading => _isLoading;
  String? get error => _error;

  ConsentProvider() {
    _initializeConsents();
  }

  void _initializeConsents() {
    _consents.addAll([
      ConsentItem(
        id: '1',
        category: 'Email',
        description: 'Marketing emails and newsletters',
        isEnabled: true,
        grantedAt: DateTime.now().subtract(const Duration(days: 30)),
        scope: 'Marketing',
      ),
      ConsentItem(
        id: '2',
        category: 'Location',
        description: 'GPS location for personalized content',
        isEnabled: true,
        grantedAt: DateTime.now().subtract(const Duration(days: 15)),
        scope: 'Personalization',
      ),
      ConsentItem(
        id: '3',
        category: 'Financial Data',
        description: 'Payment history and transaction data',
        isEnabled: false,
        grantedAt: null,
        scope: 'Essential',
      ),
      ConsentItem(
        id: '4',
        category: 'Analytics',
        description: 'Usage analytics and performance data',
        isEnabled: true,
        grantedAt: DateTime.now().subtract(const Duration(days: 7)),
        scope: 'Analytics',
      ),
    ]);
  }

  Future<void> toggleConsent(String consentId, bool value) async {
    try {
      _setLoading(true);
      _clearError();

      final index = _consents.indexWhere((consent) => consent.id == consentId);
      if (index == -1) {
        throw Exception('Consent not found');
      }

      final consent = _consents[index];
      final updatedConsent = consent.copyWith(
        isEnabled: value,
        grantedAt: value ? DateTime.now() : consent.grantedAt,
      );

      _consents[index] = updatedConsent;
      notifyListeners();

      // Simulate blockchain transaction
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      _setError('Failed to update consent: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addConsent({
    required String category,
    required String description,
    required String scope,
    DateTime? expiryDate,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final newConsent = ConsentItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        category: category,
        description: description,
        isEnabled: true,
        grantedAt: DateTime.now(),
        expiryDate: expiryDate,
        scope: scope,
      );

      _consents.add(newConsent);
      notifyListeners();

      // Simulate blockchain transaction
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      _setError('Failed to add consent: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> removeConsent(String consentId) async {
    try {
      _setLoading(true);
      _clearError();

      _consents.removeWhere((consent) => consent.id == consentId);
      notifyListeners();

      // Simulate blockchain transaction
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      _setError('Failed to remove consent: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> revokeConsent(String consentId) async {
    await toggleConsent(consentId, false);
  }

  ConsentItem? getConsentById(String id) {
    try {
      return _consents.firstWhere((consent) => consent.id == id);
    } catch (e) {
      return null;
    }
  }

  List<ConsentItem> getConsentsByCategory(String category) {
    return _consents.where((consent) => consent.category == category).toList();
  }

  List<ConsentItem> getEnabledConsents() {
    return _consents.where((consent) => consent.isEnabled).toList();
  }

  List<ConsentItem> getDisabledConsents() {
    return _consents.where((consent) => !consent.isEnabled).toList();
  }

  int get totalConsents => _consents.length;
  int get enabledConsents => _consents.where((c) => c.isEnabled).length;
  int get disabledConsents => _consents.where((c) => !c.isEnabled).length;

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
