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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  battleViewModelState?.myMove == true ? 'Ваш ход' : 'Ход соперника',
                  style: TextStyle(
                    color: battleViewModelState?.myMove == true ? Colors.green : Colors.red
                  )
                ),
              ),


              Center(
                child: BattleGrid(myShips: true),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: () => ref.read(gameNotifierProvider.notifier).cancelGame(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 128, 128, 128),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Cancel Game'),
                  ),
                ),
              ),

            ],
          ),
          MenuBtn(scaffoldKey: _scaffoldKey),
        ],
      ),
    );
  }
}