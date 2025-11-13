import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:seabattle/core/storage/storage_models.dart';

class HiveStorage {
  static const String settingsBoxName = 'settings';
  static const String statisticsBoxName = 'statistics';

  static Future<void> init() async {
    try {
      await Hive.initFlutter();

      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(SettingsModelAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(StatisticsAdapter());
      }

      await Hive.openBox(settingsBoxName);
      await Hive.openBox(statisticsBoxName);

      if (kDebugMode) {
        await debugPrintBoxes();
      }
    } catch (e) {
      debugPrint('Hive initialization error: $e');
    }
  }

  static Box get settingsBox => Hive.box(settingsBoxName);
  static Box get statisticsBox => Hive.box(statisticsBoxName);

  // Удаляет конкретный бокс по имени
  static Future<void> deleteBox(String boxName) async {
    try {
      if (kDebugMode) {
        debugPrint('Deleting box: $boxName');
      }

      if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).close();
      }
      await Hive.deleteBoxFromDisk(boxName);

      if (kDebugMode) {
        debugPrint('Successfully deleted box: $boxName');
      }
    } catch (e) {
      debugPrint('Error deleting box $boxName: $e');
    }
  }

  // Удаляет все боксы
  static Future<void> deleteAllBoxes() async {
    try {
      if (kDebugMode) {
        debugPrint('Deleting all boxes...');
      }

      final knownBoxes = [settingsBoxName, statisticsBoxName];

      for (final boxName in knownBoxes) {
        await deleteBox(boxName);
      }

      if (kDebugMode) {
        debugPrint('Successfully deleted all boxes');
      }
    } catch (e) {
      debugPrint('Error deleting all boxes: $e');
    }
  }

  // Очищает содержимое бокса (удаляет все данные, но оставляет бокс)
  static Future<void> clearBox(String boxName) async {
    try {
      if (kDebugMode) {
        debugPrint('Clearing box: $boxName');
      }

      if (Hive.isBoxOpen(boxName)) {
        final box = Hive.box(boxName);
        await box.clear();

        if (kDebugMode) {
          debugPrint('Successfully cleared box: $boxName');
        }
      }
    } catch (e) {
      debugPrint('Error clearing box $boxName: $e');
    }
  }

  // Очищает содержимое всех боксов
  static Future<void> clearAllBoxes() async {
    try {
      if (kDebugMode) {
        debugPrint('Clearing all boxes...');
      }

      final knownBoxes = [settingsBoxName, statisticsBoxName];

      for (final boxName in knownBoxes) {
        await clearBox(boxName);
      }

      if (kDebugMode) {
        debugPrint('Successfully cleared all boxes');
      }
    } catch (e) {
      debugPrint('Error clearing all boxes: $e');
    }
  }

  // Проверяет, существует ли бокс
  static Future<bool> boxExists(String boxName) async {
    try {
      return await Hive.boxExists(boxName);
    } catch (e) {
      return false;
    }
  }

  static Future<void> debugPrintBoxes() async {
    debugPrint('=== Hive Boxes Debug Info ===');
    final knownBoxes = [settingsBoxName, statisticsBoxName];
    for (final boxName in knownBoxes) {
      try {
        final box = Hive.box(boxName);
        debugPrint('Box: $boxName');
        debugPrint('  Is Open: ${box.isOpen}');
        debugPrint('  Length: ${box.length}');
        debugPrint('  Exists: ${await boxExists(boxName)}');

        if (box.isOpen && box.length > 0) {
          debugPrint('  Keys: ${box.keys.toList()}');
          // if (box.length > 5) {
          //   debugPrint('  ... and ${box.length - 5} more items');
          // }
        }
      } catch (e) {
        debugPrint('Box: $boxName - Error: $e');
      }
    }
  }

  static Future<void> debugPrintBox(String boxName) async {
    debugPrint('=== Hive Box Debug Info ===');
    final box = Hive.box(boxName);
    debugPrint('Box: $boxName');
    debugPrint('  Is Open: ${box.isOpen}');
    debugPrint('  Length: ${box.length}');

    if (box.isOpen && box.length > 0) {
      debugPrint('  Keys: ${box.keys.toList()}');
      for (final key in box.keys) {
        debugPrint('  Key: $key');
        debugPrint('  Value: ${box.get(key)}');
      }
    }
  }
}
