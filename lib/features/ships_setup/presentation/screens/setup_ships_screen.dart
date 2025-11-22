import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/battle/providers/battle_provider.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/shared/entities/game.dart';
import 'package:seabattle/shared/providers/ble_provider.dart';
import 'package:seabattle/shared/providers/game_provider.dart';
import 'package:seabattle/features/ships_setup/presentation/widgets/ship_type_button.dart';
import 'package:seabattle/features/ships_setup/presentation/widgets/ship_setup_grid.dart';
import 'package:seabattle/app/i18n/strings.g.dart';
import 'package:seabattle/features/ships_setup/presentation/viewmodels/setup_ships_viewmodel.dart';
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

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    ref.watch(battleViewModelProvider);
    final gameNotifier = ref.watch(gameNotifierProvider);
    final setupShipsViewModel = ref.watch(setupShipsViewModelProvider);
    final setupShipsViewModelState = setupShipsViewModel.value;
    final setupShipsViewModelNotifier = ref.read(setupShipsViewModelProvider.notifier);

    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      body:
        gameNotifier.when(
          data: (data) =>
            Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (final s in [4, 3])
                                      ShipTypeButton(shipSize: s),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (final s in [2, 1])
                                      ShipTypeButton(shipSize: s),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.rotate_90_degrees_ccw),
                                      tooltip: 'Повернуть',
                                      onPressed:
                                          () => ref.read(setupShipsViewModelProvider.notifier).rotateSelectedOrientation(),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.undo),
                                      tooltip: 'Удалить последний',
                                      onPressed: () => ref.read(setupShipsViewModelProvider.notifier).removeLastShip(),
                                    ),
                                    IconButton(
                                      disabledColor: Colors.grey.shade300,
                                      icon: const Icon(Icons.auto_awesome),
                                      tooltip: 'А',
                                      onPressed: setupShipsViewModelState != null &&
                                                setupShipsViewModelNotifier.countNeedPlaceShips() > 0
                                          ? () => ref.read(setupShipsViewModelProvider.notifier).autoPlaceShips()
                                          : null,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.clear),
                                      tooltip: 'Очистить',
                                      onPressed: () => ref.read(setupShipsViewModelProvider.notifier).clearShips(),
                                    ),
                                    Text(setupShipsViewModelNotifier.countNeedPlaceShips().toString()),
                                  ]
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: ShipSetupGrid(),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              buttonActionStart = true;
                              ref.read(gameNotifierProvider.notifier).startGame();
                            },
                            child: Text(t.setupships.buttons.startGame),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              buttonActionStart = false;
                              ref.read(gameNotifierProvider.notifier).cancelGame();
                            },
                            child: Text(t.setupships.buttons.cancelGame),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text('GameID: ${ref.watch(gameNotifierProvider).value?.game?.id ?? 0}'),
                        ),
                      ],
                    ),
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
                await ref.read(gameNotifierProvider.notifier).updateGame(gameNotifier.value?.game?.id ?? 0, GameAction.cancel);
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
