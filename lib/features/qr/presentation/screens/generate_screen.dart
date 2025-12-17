import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/app/styles/media.dart';
import 'package:seabattle/app/i18n/strings.g.dart';
import 'package:seabattle/features/qr/presentation/styles/buttons.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/shared/presentation/widgets/my_error_widget.dart';
import 'package:seabattle/features/battle/providers/battle_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(battleViewModelProvider.future);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameNotifier = ref.watch(gameNotifierProvider);
    final t = context.t;

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 20,
          fontWeight: .bold
        ),

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            ref.read(gameNotifierProvider.notifier).resetGame();
          } ,
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(t.qr.creatingGame),
      ),
      body:
        gameNotifier.when(
          data: (data) => SizedBox(
            width: .infinity,
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              children: [
              if (gameNotifier.value?.game?.id == null)
                ElevatedButton(
                  style: createGameBtnStyle(context),
                  onPressed: () => ref.read(gameNotifierProvider.notifier).createGame(),
                  child: Text(t.qr.createGame, style: createGameBtnTextStyle(context))
                ),
              if (gameNotifier.value?.game?.id != null) ...[
                QRCode(
                  data: gameNotifier.value?.game?.id.toString() ?? '',
                  size: deviceType(context) == DeviceType.phone ? 300 : 400,
                  padding: const .all(10.0),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(height: 32),
                TextButton(
                  style: cancelGameBtnTextStyle(context),
                  onPressed: () => ref.read(gameNotifierProvider.notifier).cancelGame(),
                  child: Text(t.qr.cancelGame),
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