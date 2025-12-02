import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExplosionImagesCache {
  ExplosionImagesCache(this._images);

  final Map<String, ui.Image> _images;

  ui.Image? imageForType(String type) => _images[type];

  // Iterable<String> get availableSizes => _images.keys;
}

final explosionImagesProvider = FutureProvider<ExplosionImagesCache>((ref) async {
  final images = <String, ui.Image>{};
  for (final entry in _assetsBySize.entries) {
    images[entry.key] = await _loadImage(entry.value);
  }

  return ExplosionImagesCache(images);
});

// Соответствие размера корабля (число палуб) пути к ассету.
const Map<String, String> _assetsBySize = {
  'wounded': 'assets/images/wounded.png',
  'dead': 'assets/images/dead.png',
  'miss': 'assets/images/miss.png',
};

Future<ui.Image> _loadImage(String assetPath) async {
  try {
    // Читаем бинарные данные ассета из bundle.
    final data = await rootBundle.load(assetPath);
    // Превращаем данные в кодек, чтобы получить ui.Image.
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return frame.image;
  } catch (error) {
    // Пробрасываем ошибку выше, чтобы FutureProvider перешёл в состояние error.
    rethrow;
  }
}