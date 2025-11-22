import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/qr/presentation/viewmodels/qr_scan_viewmodel.dart';

final qrScanViewModelProvider = AsyncNotifierProvider<QrScanViewModelNotifier, QrScanState>(
  () => QrScanViewModelNotifier(),
);