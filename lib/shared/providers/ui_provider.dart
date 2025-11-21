import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CellSizeNotifier extends Notifier<double> {
  @override
  double build() => -1;

  void init(BuildContext context) {
    if (state != -1) return;

    // Откладываем изменение состояния до завершения построения виджета
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final width = MediaQuery.sizeOf(context).width;
      state = (width - 120) / 10;
    });
  }
}

final cellSizeProvider =
    NotifierProvider<CellSizeNotifier, double>(CellSizeNotifier.new);