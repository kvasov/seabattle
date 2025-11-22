import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/shared/widgets/my_error_widget.dart';
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

        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            ref.read(gameNotifierProvider.notifier).resetGame();
          } ,
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
                QRCode(
                  data: gameNotifier.value?.game?.id.toString() ?? '',
                  size: 300,
                  padding: const EdgeInsets.all(10.0),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => ref.read(gameNotifierProvider.notifier).cancelGame(),
                  child: const Text('Отменить игру'),
                ),
              ],
            ],
            ),
          ),
          error: (error, stackTrace) => MyErrorWidget(error: 'Error: $error', retryCallback: () {
            if (gameNotifier.value?.game?.id != null) {
              ref.read(gameNotifierProvider.notifier).cancelGame();
            } else {
              ref.read(gameNotifierProvider.notifier).createGame();
            }
          } ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
    );
  }
}