import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/entities/game.dart';
import 'package:seabattle/features/qr/presentation/widgets/scanner.dart';
import 'package:seabattle/features/qr/providers/qr_scan_viewmodel_provider.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/shared/presentation/widgets/my_error_widget.dart';
import 'package:seabattle/app/i18n/strings.g.dart';
import 'package:seabattle/features/battle/providers/battle_provider.dart';

class ScanQRScreen extends ConsumerStatefulWidget {
  const ScanQRScreen({super.key});

  @override
  ConsumerState<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends ConsumerState<ScanQRScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(battleViewModelProvider.future);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameNotifier = ref.watch(gameNotifierProvider);
    final qrScanState = ref.watch(qrScanViewModelProvider);
    final qrCode = qrScanState.value?.qrCode;
    final gameId = qrCode?.isNotEmpty == true ? int.tryParse(qrCode!) : null;
    final t = context.t;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            ref.read(qrScanViewModelProvider.notifier).reset();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(t.qr.scanQrCode),
      ),
      body:
        gameNotifier.when(
          data: (data) =>
            Center(
              child: Column(
                children: [
                  ScannerWidget(),
                  if (qrCode?.isNotEmpty == true)
                    if (gameId != null)
                      ElevatedButton(
                        onPressed: () => ref.read(gameNotifierProvider.notifier).updateGame(gameId, GameAction.accept),
                        child: Text(t.qr.acceptGame)
                      )
                    else
                      Padding(
                        padding: const .all(8.0),
                        child: Text(
                          t.qr.invalidQrCode,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  TextButton(
                    onPressed: () => ref.read(gameNotifierProvider.notifier).updateGame(0, GameAction.accept),
                    child: Text(t.qr.acceptLastGame)
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