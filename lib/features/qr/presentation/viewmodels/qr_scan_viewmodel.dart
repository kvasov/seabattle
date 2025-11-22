import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanState {
  final String qrCode;
  final bool isLoading;
  final bool isError;
  final String errorMessage;

  QrScanState({
    required this.qrCode,
    required this.isLoading,
    required this.isError,
    required this.errorMessage,
  });

  QrScanState copyWith({
    String? qrCode,
    bool? isLoading,
    bool? isError,
    String? errorMessage,
  }) {
    return QrScanState(
      qrCode: qrCode ?? this.qrCode,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class QrScanViewModelNotifier extends AsyncNotifier<QrScanState> {
  @override
  QrScanState build() {
    return QrScanState(
      qrCode: '',
      isLoading: false,
      isError: false,
      errorMessage: '',
    );
  }

  void handleBarcode(BarcodeCapture barcodes) {
    state = AsyncValue.data(state.value!.copyWith(
      qrCode: barcodes.barcodes.firstOrNull?.displayValue ?? '',
    ));
  }

  void reset() {
    state = AsyncValue.data(QrScanState(
      qrCode: '',
      isLoading: false,
      isError: false,
      errorMessage: '',
    ));
  }
}