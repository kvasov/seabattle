import 'package:seabattle/core/storage/hive_storage.dart';

Future<void> init() async {
  await HiveStorage.init();
}
