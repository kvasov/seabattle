import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/shared/entities/game.dart';

class ScanQRScreen extends ConsumerStatefulWidget {
  const ScanQRScreen({super.key});

  @override
  ConsumerState<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends ConsumerState<ScanQRScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Сканирование QR-кода'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Scan QR Screen'),
            TextButton(
              onPressed: () => ref.read(gameNotifierProvider.notifier).updateGame(6, GameAction.accept),
              child: const Text('Accept Game #6')
            ),
          ],
        ),
      ),
    );
  }
}