import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:seabattle/features/battle/providers/battle_provider.dart';

class ArrowRive extends ConsumerStatefulWidget {
  const ArrowRive({super.key});

  @override
  ConsumerState<ArrowRive> createState() => _ArrowRiveState();
}

class _ArrowRiveState extends ConsumerState<ArrowRive> {
  late final fileLoader = FileLoader.fromAsset(
    "assets/rive/arrow.riv",
    riveFactory: Factory.rive
  );
  bool _isLoaded = false;
  dynamic _myMoveInput;

  void _updateMyMoveInput(bool isMyMove) {
    if (_myMoveInput != null) {
      (_myMoveInput as dynamic).value = isMyMove;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    fileLoader.dispose();
    super.dispose();
  }

  void _initializeStateMachine(RiveLoaded state) {
    if (_isLoaded) return;
    _isLoaded = true;
    try {
      final stateMachine = state.controller.stateMachine;
      final myMoveInput = stateMachine.boolean('fav');
      if (myMoveInput != null) {
        _myMoveInput = myMoveInput;

        final battleProvider = ref.read(battleViewModelProvider);
        debugPrint('battleProvider: ${battleProvider.value?.myMove}');
        if (battleProvider.value != null) {
          _updateMyMoveInput(battleProvider.value!.myMove);
        }
      } else {
        debugPrint('fav input не найден');
      }
    } catch (e) {
      debugPrint('Ошибка при инициализации: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final battleState = ref.watch(battleViewModelProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateMyMoveInput(battleState.value!.myMove);
    });

    return RiveWidgetBuilder(
      fileLoader: fileLoader,
      stateMachineSelector: StateMachineDefault(),
      builder: (context, state) => switch (state) {
        RiveLoading() => const Center(child: CircularProgressIndicator()),
        RiveFailed() => Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              const Icon(Icons.error, size: 48, color: Colors.red),
              const SizedBox(height: 8),
              const Text('Ошибка загрузки'),
              Text('${state.error}', style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
        RiveLoaded() => () {
          if (!_isLoaded) {
            _initializeStateMachine(state);
          }
          return SizedBox(
            width: 30,
            height: 30,
            child: RiveWidget(
              controller: state.controller,
              fit: Fit.contain,
            ),
          );
        }(),
      },
    );
  }
}
