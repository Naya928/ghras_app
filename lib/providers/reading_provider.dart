import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/plant_item.dart';
import '../models/reading_progress.dart';

// الـ Provider الرئيسي للتطبيق
final readingProvider =
    StateNotifierProvider<ReadingNotifier, ReadingProgress>((ref) {
  return ReadingNotifier();
});

class ReadingNotifier extends StateNotifier<ReadingProgress> {
  // اسم الصندوق في Hive
  static const String _boxName = 'progress_box';

  ReadingNotifier() : super(ReadingProgress()) {
    _loadFromStorage();
  }

  // تحميل البيانات المحفوظة عند فتح التطبيق
  void _loadFromStorage() {
    final box = Hive.box<ReadingProgress>(_boxName);
    final saved = box.get('progress');

    if (saved != null) {
      state = saved;
    } else {
      // أول مرة يفتح التطبيق — ابدأ من صفر
      final fresh = ReadingProgress();
      box.put('progress', fresh);
      state = fresh;
    }
  }

  // حفظ في Hive بعد كل تغيير
  void _save() {
    final box = Hive.box<ReadingProgress>(_boxName);
    box.put('progress', state);
  }

  // تحديث الصفحات المقروءة
  void updatePages(int pages) {
    // تأكد إن القيمة بين 0 و 300
    final clamped = pages.clamp(0, 300);

    state = ReadingProgress(
      pagesRead: clamped,
      placedPlants: state.placedPlants,
    );

    _save();
  }

  // وضع كائن في الحديقة
  void placePlant(PlantType type, double x, double y) {
    // تحقق إن عنده رصيد متاح
    final available = switch (type) {
      PlantType.seedling => state.availableSeedlings,
      PlantType.flower   => state.availableFlowers,
      PlantType.tree     => state.availableTrees,
    };

    if (available <= 0) return; // ما عنده رصيد

    final newPlant = PlantItem(
      type: type,
      x: x,
      y: y,
      isPlaced: true,
    );

    final updatedPlants = [...state.placedPlants, newPlant];

    state = ReadingProgress(
      pagesRead: state.pagesRead,
      placedPlants: updatedPlants,
    );

    _save();
  }

  // إزالة كائن من الحديقة (يرجع للمخزون)
  void removePlant(PlantItem plant) {
    final updatedPlants = state.placedPlants
        .where((p) => p != plant)
        .toList();

    state = ReadingProgress(
      pagesRead: state.pagesRead,
      placedPlants: updatedPlants,
    );

    _save();
  }

  // إعادة ضبط كامل (للتجربة)
  void reset() {
    state = ReadingProgress();
    _save();
  }
}