import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Center(
                child: Column(
                  children: [
                    TitleWidget(),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CreateGame(),
                        AcceptGame(),
                      ],
                    ),
                    SizedBox(height: 20),
                    Settings(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}