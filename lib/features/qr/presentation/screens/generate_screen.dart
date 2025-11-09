import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/providers/game_provider.dart';

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
        title: const Text('Генерация QR-кода'),
      ),
      body:
        gameNotifier.when(
          data: (data) => Column(
            children: [
              Center(child: Text('Generate QR Screen')),
              TextButton(
                onPressed: () => ref.read(gameNotifierProvider.notifier).createGame(),
                child: const Text('Create Game')
              ),
              Text(gameNotifier.value?.game?.id.toString() ?? ''),
            ],
          ),
          error: (error, stackTrace) => Text('Error: $error'),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
    );
  }
}