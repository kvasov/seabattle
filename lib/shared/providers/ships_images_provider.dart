import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShipsImagesCache {
  ShipsImagesCache(this._images);

  final Map<int, ui.Image> _images;

  ui.Image? imageForSize(int size) => _images[size];

  Iterable<int> get availableSizes => _images.keys;
}

final shipsImagesProvider = FutureProvider<ShipsImagesCache>((ref) async {
  final images = <int, ui.Image>{};
  for (final entry in _assetsBySize.entries) {
    images[entry.key] = await _loadImage(entry.value);
  }

  return ShipsImagesCache(images);
});

// Соответствие размера корабля (число палуб) пути к ассету.
const Map<int, String> _assetsBySize = {
  1: 'assets/images/ships/x1.png',
  2: 'assets/images/ships/x2.png',
  3: 'assets/images/ships/x3.png',
  4: 'assets/images/ships/x4.png',
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