import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/app/styles/media.dart';
import 'package:seabattle/features/home/presentation/widgets/create_game.dart';
import 'package:seabattle/features/home/presentation/widgets/accept_game.dart';
import 'package:seabattle/features/home/presentation/widgets/settings.dart';
import 'package:seabattle/features/home/presentation/widgets/title.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bgImage = Theme.of(context).brightness == Brightness.dark
        ? const AssetImage('assets/images/bg_dark.png')
        : const AssetImage('assets/images/bg.png');

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: bgImage,
            fit: .cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              Transform.translate(
                offset: Offset(0, -MediaQuery.of(context).size.height * 0.1),
                child: Padding(
                  padding: const .all(16.0),
                  child: Column(
                    crossAxisAlignment: .center,
                    children: [
                      TitleWidget(),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: deviceType(context) == DeviceType.tablet
                            ? .center
                            : .spaceAround,
                        children: [
                          CreateGameButton(),
                          SizedBox(width: deviceType(context) == DeviceType.tablet ? 20 : 16),
                          AcceptGameButton(),
                        ],
                      ),
                      SizedBox(height: 20),
                      Settings(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}