import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

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

const Map<int, String> _assetsBySize = {
  1: 'assets/images/ships/x1.png',
  2: 'assets/images/ships/x2.png',
  3: 'assets/images/ships/x3.png',
  4: 'assets/images/ships/x4.png',
};

Future<ui.Image> _loadImage(String assetPath) async {
  try {
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    debugPrint('frame: ${frame.image.width}x${frame.image.height}');
    return frame.image;
  } catch (error, stack) {
    debugPrint('❌ Ошибка загрузки $assetPath: $error');
    throw error; // даст знать `FutureProvider`, что ассет не загрузился
  }
}