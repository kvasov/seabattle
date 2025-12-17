import 'package:flutter/material.dart';
import 'package:seabattle/app/styles/media.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/qr/presentation/widgets/periscope_overlay.dart';
import 'package:seabattle/utils/bg_wave.dart';
import 'package:seabattle/features/qr/presentation/widgets/periscope_ruler.dart';
import 'package:seabattle/features/qr/providers/qr_scan_viewmodel_provider.dart';

class ScannerWidget extends ConsumerStatefulWidget {
  const ScannerWidget({super.key});

  @override
  ConsumerState<ScannerWidget> createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends ConsumerState<ScannerWidget> with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(qrScanViewModelProvider.notifier).reset();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      controller.stop();
    } else if (state == AppLifecycleState.resumed) {
      controller.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    final qrScanNotifier = ref.read(qrScanViewModelProvider.notifier);

    return SizedBox(
      width: deviceType(context) == DeviceType.phone ? 300 : 600,
      height: deviceType(context) == DeviceType.phone ? 300 : 600,
      child: Padding(
        padding: const .all(24.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              SizedBox(
                width: .infinity,
                height: .infinity,
                child: MobileScanner(
                  controller: controller,
                  onDetect: qrScanNotifier.handleBarcode,
                ),
              ),
              SizedBox(
                width: .infinity,
                height: .infinity,
                child: Container(
                  color: const Color.fromARGB(103, 62, 184, 228),
                  child: null,
                ),
              ),
              Positioned.fill(
                bottom: 0,
                child: BgWave(),
              ),
              Positioned.fill(
                child: PeriscopeRuler(),
              ),
              Positioned.fill(
                child: PeriscopeOverlay(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}