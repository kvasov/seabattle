import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:qr_bar_code/qr/qr.dart';

class GenerateQRScreen extends ConsumerStatefulWidget {
  const GenerateQRScreen({super.key});

  @override
  ConsumerState<GenerateQRScreen> createState() => _GenerateQRScreenState();
}

class _GenerateQRScreenState extends ConsumerState<GenerateQRScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gameNotifier = ref.watch(gameNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Создание игры'),
      ),
      body:
        gameNotifier.when(
          data: (data) => SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              if (gameNotifier.value?.game?.id == null)
                ElevatedButton(
                  onPressed: () => ref.read(gameNotifierProvider.notifier).createGame(),
                  child: const Text('Создать игру')
                ),
              Text(gameNotifier.value?.game?.id.toString() ?? ''),
              if (gameNotifier.value?.game?.id != null) ...[
                TextButton(
                  onPressed: () => ref.read(gameNotifierProvider.notifier).cancelGame(),
                  child: const Text('Отменить игру'),
                ),
                QRCode(
                  data: gameNotifier.value?.game?.id.toString() ?? '',
                  size: 300,
                  padding: const EdgeInsets.all(10.0),
                  backgroundColor: Colors.transparent,
                  gapless: false,
                  eyeStyle: const QREyeStyle(eyeShape: QREyeShape.circle, color: Colors.black),
                  dataModuleStyle: const QRDataModuleStyle(dataModuleShape: QRDataModuleShape.circle, color: Colors.black),
                ),
              ],
            ],
            ),
          ),
          error: (error, stackTrace) => Text('Error: $error'),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
    );
  }
}