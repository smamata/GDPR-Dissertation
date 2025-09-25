import 'package:flutter/foundation.dart';

class OptimizationMetrics {
  final double gasEfficiency;
  final double processingTime;
  final double costSavings;
  final double complianceScore;
  final int totalTransactions;
  final double averageGasUsed;
  final double totalCost;
  final DateTime lastUpdated;

  OptimizationMetrics({
    required this.gasEfficiency,
    required this.processingTime,
    required this.costSavings,
    required this.complianceScore,
    required this.totalTransactions,
    required this.averageGasUsed,
    required this.totalCost,
    required this.lastUpdated,
  });
}

class PerformanceInsight {
  final String title;
  final String description;
  final String category;
  final String impact;
  final String recommendation;
  final bool isImplemented;
  final double potentialSavings;

  PerformanceInsight({
    required this.title,
    required this.description,
    required this.category,
    required this.impact,
    required this.recommendation,
    required this.isImplemented,
    required this.potentialSavings,
  });
}

class ContractComparison {
  final String contractName;
  final double gasUsed;
  final double cost;
  final double efficiency;
  final List<String> features;
  final String recommendation;

  ContractComparison({
    required this.contractName,
    required this.gasUsed,
    required this.cost,
    required this.efficiency,
    required this.features,
    required this.recommendation,
  });
}

class AnalyticsProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  OptimizationMetrics? _metrics;
  List<PerformanceInsight> _insights = [];
  List<ContractComparison> _contractComparisons = [];
  String _selectedTimeframe = '30d';

  bool get isLoading => _isLoading;
  String? get error => _error;
  OptimizationMetrics? get metrics => _metrics;
  List<PerformanceInsight> get insights => _insights;
  List<ContractComparison> get contractComparisons => _contractComparisons;
  String get selectedTimeframe => _selectedTimeframe;

  AnalyticsProvider() {
    _initializeData();
  }

  void _initializeData() {
    _metrics = OptimizationMetrics(
      gasEfficiency: 87.5,
      processingTime: 2.3,
      costSavings: 34.2,
      complianceScore: 94.8,
      totalTransactions: 1247,
      averageGasUsed: 156789,
      totalCost: 0.0234,
      lastUpdated: DateTime.now(),
    );

    _insights = [
      PerformanceInsight(
        title: 'Batch Processing Optimization',
        description: 'Process multiple consent updates in a single transaction',
        category: 'Gas Optimization',
        impact: 'High',
        recommendation: 'Implement batch processing for consent updates to reduce gas costs by up to 40%',
        isImplemented: false,
        potentialSavings: 0.0089,
      ),
      PerformanceInsight(
        title: 'Event Optimization',
        description: 'Use indexed events for better query performance',
        category: 'Performance',
        impact: 'Medium',
        recommendation: 'Add indexed parameters to events for faster filtering and reduced query costs',
        isImplemented: true,
        potentialSavings: 0.0034,
      ),
      PerformanceInsight(
        title: 'Storage Packing',
        description: 'Optimize storage layout to reduce gas consumption',
        category: 'Storage',
        impact: 'High',
        recommendation: 'Pack struct fields to use fewer storage slots, reducing gas by 15-20%',
        isImplemented: false,
        potentialSavings: 0.0056,
      ),
      PerformanceInsight(
        title: 'Access Control Optimization',
        description: 'Implement efficient role-based access control',
        category: 'Security',
        impact: 'Medium',
        recommendation: 'Use OpenZeppelin AccessControl for gas-efficient permission management',
        isImplemented: true,
        potentialSavings: 0.0023,
      ),
      PerformanceInsight(
        title: 'Deletion Request Batching',
        description: 'Process multiple deletion requests in batches',
        category: 'Gas Optimization',
        impact: 'High',
        recommendation: 'Implement batch deletion processing to reduce transaction costs',
        isImplemented: false,
        potentialSavings: 0.0123,
      ),
      PerformanceInsight(
        title: 'Data Compression',
        description: 'Compress data before storing on-chain',
        category: 'Storage',
        impact: 'Medium',
        recommendation: 'Use compression algorithms for large data sets to reduce storage costs',
        isImplemented: false,
        potentialSavings: 0.0045,
      ),
    ];

    _contractComparisons = [
      ContractComparison(
        contractName: 'ConsentBasic',
        gasUsed: 234567,
        cost: 0.0456,
        efficiency: 65.2,
        features: ['Basic consent management', 'Simple events', 'Basic access control'],
        recommendation: 'Suitable for simple use cases with low transaction volume',
      ),
      ContractComparison(
        contractName: 'ConsentOptimized',
        gasUsed: 156789,
        cost: 0.0234,
        efficiency: 87.5,
        features: ['Optimized storage', 'Batch processing', 'Advanced events', 'Gas-efficient operations'],
        recommendation: 'Recommended for production use with high transaction volume',
      ),
      ContractComparison(
        contractName: 'ConsentMinimalEvent',
        gasUsed: 189234,
        cost: 0.0312,
        efficiency: 78.3,
        features: ['Minimal events', 'Reduced logging', 'Basic functionality'],
        recommendation: 'Good balance between functionality and gas efficiency',
      ),
    ];
  }

  void setTimeframe(String timeframe) {
    _selectedTimeframe = timeframe;
    _refreshData();
    notifyListeners();
  }

  Future<void> _refreshData() async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Update metrics based on timeframe
      final multiplier = _getTimeframeMultiplier(_selectedTimeframe);
      _metrics = OptimizationMetrics(
        gasEfficiency: 87.5 + (multiplier * 2.3),
        processingTime: 2.3 - (multiplier * 0.1),
        costSavings: 34.2 + (multiplier * 5.6),
        complianceScore: 94.8 + (multiplier * 1.2),
        totalTransactions: (1247 * multiplier).round(),
        averageGasUsed: 156789 - (multiplier * 5000),
        totalCost: 0.0234 * multiplier,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      _setError('Failed to refresh analytics data: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  double _getTimeframeMultiplier(String timeframe) {
    switch (timeframe) {
      case '7d':
        return 0.3;
      case '30d':
        return 1.0;
      case '90d':
        return 2.8;
      case '1y':
        return 12.0;
      default:
        return 1.0;
    }
  }

  List<PerformanceInsight> getInsightsByCategory(String category) {
    return _insights.where((insight) => insight.category == category).toList();
  }

  List<PerformanceInsight> getImplementedInsights() {
    return _insights.where((insight) => insight.isImplemented).toList();
  }

  List<PerformanceInsight> getPendingInsights() {
    return _insights.where((insight) => !insight.isImplemented).toList();
  }

  double getTotalPotentialSavings() {
    return _insights
        .where((insight) => !insight.isImplemented)
        .fold(0.0, (sum, insight) => sum + insight.potentialSavings);
  }

  int getInsightCountByImpact(String impact) {
    return _insights.where((insight) => insight.impact == impact).length;
  }

  ContractComparison? getMostEfficientContract() {
    if (_contractComparisons.isEmpty) return null;
    return _contractComparisons.reduce((a, b) => a.efficiency > b.efficiency ? a : b);
  }

  ContractComparison? getLeastEfficientContract() {
    if (_contractComparisons.isEmpty) return null;
    return _contractComparisons.reduce((a, b) => a.efficiency < b.efficiency ? a : b);
  }

  Future<void> implementInsight(String insightTitle) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate implementation
      await Future.delayed(const Duration(seconds: 2));
      
      final index = _insights.indexWhere((insight) => insight.title == insightTitle);
      if (index != -1) {
        _insights[index] = PerformanceInsight(
          title: _insights[index].title,
          description: _insights[index].description,
          category: _insights[index].category,
          impact: _insights[index].impact,
          recommendation: _insights[index].recommendation,
          isImplemented: true,
          potentialSavings: _insights[index].potentialSavings,
        );
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to implement insight: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshAnalytics() async {
    await _refreshData();
  }

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
