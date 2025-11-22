import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/providers/navigation_provider.dart';
import 'package:seabattle/features/splash/widgets/shader_mask.dart';

class SplashScreen extends ConsumerStatefulWidget {

  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 1000), () {
      if (!mounted) return;
      ref.read(navigationProvider.notifier).goToHomeScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(-1, -0.2),
            end: Alignment(1.0, 0.8),
            colors: [
              Color.fromARGB(255, 11, 89, 141),
              Color.fromARGB(255, 160, 193, 213),
              Color.fromARGB(255, 221, 209, 185),
            ],
            stops: [0.0, 0.6, 1],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextMaskWidget(),
                SizedBox(height: 64),
                const Center(child: CircularProgressIndicator(color: Colors.white))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
