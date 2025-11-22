import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/qr/presentation/widgets/periscope_overlay.dart';
import 'package:seabattle/features/qr/presentation/widgets/bg_wave.dart';
import 'package:seabattle/features/qr/presentation/widgets/periscope_ruler.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/shared/entities/game.dart';
import 'package:seabattle/features/qr/providers/qr_scan_viewmodel_provider.dart';
import 'package:seabattle/shared/widgets/my_error_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQRScreen extends ConsumerStatefulWidget {
  const ScanQRScreen({super.key});

  @override
  ConsumerState<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends ConsumerState<ScanQRScreen> with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(qrScanViewModelProvider.notifier).reset();
        ref.read(gameNotifierProvider.notifier).resetGame();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    debugPrint("🔥 SCANNER DISPOSE");
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      debugPrint("🔥 SCANNER STOP");
      controller.stop();
    } else if (state == AppLifecycleState.resumed) {
      debugPrint("🔥 SCANNER START");
      controller.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameNotifier = ref.watch(gameNotifierProvider);
    final qrScanNotifier = ref.read(qrScanViewModelProvider.notifier);
    final qrScanState = ref.watch(qrScanViewModelProvider);
    final qrCode = qrScanState.value?.qrCode;
    final gameId = qrCode?.isNotEmpty == true ? int.tryParse(qrCode!) : null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            ref.read(qrScanViewModelProvider.notifier).reset();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Сканирование QR-кода'),
      ),
      body:
        gameNotifier.when(
          data: (data) =>
            Center(
              child: Column(
                children: [
                  Text('Scan QR Screen'),
                  TextButton(
                    onPressed: () => ref.read(gameNotifierProvider.notifier).updateGame(0, GameAction.accept),
                    child: const Text('Accept last game in DB')
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: MobileScanner(
                            controller: controller,
                            onDetect: qrScanNotifier.handleBarcode,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 300,
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

                  if (qrCode?.isNotEmpty == true)
                    if (gameId != null)
                      ElevatedButton(
                        onPressed: () => ref.read(gameNotifierProvider.notifier).updateGame(gameId, GameAction.accept),
                        child: Text('Принять игру #$gameId')
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Неверный QR-код',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                ],
              ),
            ),
          error: (error, stackTrace) => MyErrorWidget(
            error: 'Error: $error',
            retryCallback: () => ref.read(gameNotifierProvider.notifier).updateGame(gameId ?? 0, GameAction.accept)
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
    );
  }
}