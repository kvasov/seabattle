import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seabattle/features/ships_setup/presentation/widgets/game_actions.dart';
import 'package:seabattle/features/ships_setup/presentation/widgets/isolate.dart';
import 'package:seabattle/features/ships_setup/presentation/widgets/ship_select_row.dart';
import 'package:seabattle/features/ships_setup/presentation/widgets/ship_setup_actions.dart';
import 'package:seabattle/features/ships_setup/presentation/widgets/ship_setup_grid.dart';
import 'package:seabattle/utils/bg_wave.dart';
import 'package:seabattle/shared/entities/game.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/shared/widgets/drawer.dart';
import 'package:seabattle/shared/widgets/menu_btn.dart';
import 'package:seabattle/shared/widgets/my_error_widget.dart';

class SetupShipsScreen extends ConsumerStatefulWidget {
  const SetupShipsScreen({super.key});

  @override
  ConsumerState<SetupShipsScreen> createState() => _SetupShipsScreenState();
}

class _SetupShipsScreenState extends ConsumerState<SetupShipsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool? buttonActionStart;

  void setButtonActionStart(bool value) {
    setState(() {
      buttonActionStart = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = ref.watch(gameNotifierProvider);
    final gameState = gameProvider.value;

    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      body:
        gameProvider.when(
          data: (data) =>
            Stack(
              children: [
                Positioned.fill(
                  bottom: 0,
                  child: BgWave(),
                ),
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShipSelectRow(),
                          ShipSetupActions(),
                        ],
                      ),
                      ShipSetupGrid(),
                      GameActions(
                        buttonActionStart: buttonActionStart ?? false,
                        setButtonActionStart: setButtonActionStart
                      ),
                      IsolateWidget(),
                    ],
                  ),
                ),
                MenuBtn(scaffoldKey: _scaffoldKey),
              ],
            ),
          error: (error, stackTrace) => MyErrorWidget(
            error: 'Error: $error',
            retryCallback: () async {
              if (buttonActionStart == true) {
                ref.read(gameNotifierProvider.notifier).startGame();
              } else {
                await ref.read(gameNotifierProvider.notifier).updateGame(gameState?.game?.id ?? 0, GameAction.cancel);
                final updatedState = ref.read(gameNotifierProvider);
                if (!updatedState.hasError) {
                  ref.read(navigationProvider.notifier).goToHomeScreen();
                }
              }
            }
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
    );
  }
}
