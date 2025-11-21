import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/app/i18n/strings.g.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  t.etc.bottomNavigationBar.home,
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontFamily: 'Roboto',
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    ref.read(navigationProvider.notifier).pushCreateGameScreen();
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.qr_code),
                      Text(
                        t.home.proposeGame,
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(navigationProvider.notifier).pushScanQRScreen();
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.camera_alt),
                      Text(
                        t.home.joinGame,
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(navigationProvider.notifier).pushSettingsScreen();
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.settings),
                      Text(
                        t.home.settings,
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}