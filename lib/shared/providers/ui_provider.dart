import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier для управления размером ячейки игрового поля.
///
/// Вычисляет размер ячейки на основе ширины экрана.
class CellSizeNotifier extends Notifier<double> {
  @override
  double build() => -1;

  /// Инициализирует размер ячейки на основе контекста.
  ///
  /// [context] - контекст виджета для получения размера экрана.
  void init(BuildContext context) {
    if (state != -1) return;

    // Откладываем изменение состояния до завершения построения виджета
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final width = MediaQuery.sizeOf(context).width;
      final cellSize = (width - 120) / 10;
      // Для больших экранов не нужно делать большие клетки
      state = cellSize > 50 ? 50 : cellSize;
    });
  }
}

/// Провайдер для размера ячейки игрового поля.
final cellSizeProvider =
    NotifierProvider<CellSizeNotifier, double>(CellSizeNotifier.new);