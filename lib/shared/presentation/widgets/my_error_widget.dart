import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyErrorWidget extends ConsumerWidget {
  const MyErrorWidget({super.key, required this.error, required this.retryCallback});
  final String error;
  final VoidCallback retryCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Image.asset('assets/images/error.jpg', width: double.infinity, height: double.infinity, fit: BoxFit.cover),
          Container(
            padding: const EdgeInsets.only(left: 32, right: 32, top: 64, bottom: 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    softWrap: true,
                    TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.error, color: Colors.red, size: 24),
                          alignment: PlaceholderAlignment.bottom,
                        ),
                        const TextSpan(
                          text: ' Ошибка: ',
                          style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: error,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    retryCallback();
                  },
                  child: const Text('Попробовать снова'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}