import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/features/battle/presentation/widgets/grid.dart';
import 'package:seabattle/features/battle/providers/battle_provider.dart';
import 'package:seabattle/shared/widgets/drawer.dart';
import 'package:seabattle/shared/widgets/menu_btn.dart';

class BattleScreen extends ConsumerStatefulWidget {
  const BattleScreen({super.key});

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameNotifierProvider).value;
    final battleViewModelState = ref.watch(battleViewModelProvider).value;
    debugPrint('💚 battleViewModelState: ${battleViewModelState?.toString()}');

    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (gameState?.isLoading == true)
                const CircularProgressIndicator(),
              if (gameState?.game?.opponentReady == false)
                const Text('Waiting for opponent to be ready')
              else ...[
                Center(
                  child: BattleGrid(myShips: false),
                ),
              ],
              if (gameState?.isError == true)
                Text(gameState?.errorMessage ?? ''),
              SizedBox(height: 16),
              Center(
                child: BattleGrid(myShips: true),
              ),
              Center(
                child: TextButton(
                  onPressed: () => ref.read(gameNotifierProvider.notifier).cancelGame(),
                  child: const Text('Cancel Game'),
                ),
              ),
              if (battleViewModelState?.myMove == true)
                Center(
                  child: Text('Ваш ход', style: TextStyle(color: Colors.green)),
                ),
              if (battleViewModelState?.myMove == false)
                Center(
                  child: Text('Ход соперника', style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
          MenuBtn(scaffoldKey: _scaffoldKey),
        ],
      ),
    );
  }
}