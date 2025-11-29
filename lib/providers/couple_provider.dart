import 'package:flutter/foundation.dart';
import '../models/couple.dart';
import '../services/storage_service.dart';

class CoupleProvider with ChangeNotifier {
  Couple? _couple;
  final StorageService _storageService = StorageService();

  Couple? get couple => _couple;

  bool get isConnected => _couple != null;

  Future<void> loadCouple() async {
    _couple = await _storageService.getCouple();
    notifyListeners();
  }

  Future<void> createCouple(String partner1Id, String partner2Id) async {
    _couple = Couple(
      partner1Id: partner1Id,
      partner2Id: partner2Id,
      relationshipStartDate: DateTime.now(),
    );
    await _storageService.saveCouple(_couple!);
    notifyListeners();
  }

  Future<void> addSharedNote(String note, String authorId) async {
    if (_couple == null) return;
    
    _couple!.sharedNotes.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'content': note,
      'authorId': authorId,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    await _storageService.saveCouple(_couple!);
    notifyListeners();
  }

  Future<void> addAppointment(Map<String, dynamic> appointment) async {
    if (_couple == null) return;
    
    _couple!.appointments.add(appointment);
    await _storageService.saveCouple(_couple!);
    notifyListeners();
  }
}

