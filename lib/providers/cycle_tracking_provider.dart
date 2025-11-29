import 'package:flutter/foundation.dart';
import '../models/cycle_tracking.dart';

class CycleTrackingProvider with ChangeNotifier {
  final List<CycleTracking> _trackings = [];

  List<CycleTracking> get trackings => _trackings;

  Future<void> loadTrackings() async {
    // Load from storage
    // For now, using empty list
    notifyListeners();
  }

  Future<void> addTracking(CycleTracking tracking) async {
    _trackings.add(tracking);
    await _saveTrackings();
    notifyListeners();
  }

  Future<void> updateTracking(CycleTracking tracking) async {
    final index = _trackings.indexWhere((t) => t.id == tracking.id);
    if (index != -1) {
      _trackings[index] = tracking;
      await _saveTrackings();
      notifyListeners();
    }
  }

  CycleTracking? getTrackingForDate(DateTime date) {
    try {
      return _trackings.firstWhere(
        (t) => t.date.year == date.year &&
            t.date.month == date.month &&
            t.date.day == date.day,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveTrackings() async {
    // Save to storage
    // Implementation depends on storage service
  }
}

