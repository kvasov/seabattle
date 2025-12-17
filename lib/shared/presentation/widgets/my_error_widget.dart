import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyErrorWidget extends ConsumerWidget {
  const MyErrorWidget({super.key, required this.error, required this.retryCallback});
  final String error;
  final VoidCallback retryCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: .infinity,
      height: .infinity,
      child: Stack(
        children: [
          Image.asset(
            'assets/images/error.jpg',
            width: .infinity,
            height: .infinity,
            fit: .cover
          ),
          Container(
            padding: const .only(left: 32, right: 32, top: 64, bottom: 64),
            child: Column(
              mainAxisAlignment: .spaceBetween,
              crossAxisAlignment: .center,
              children: [
                Padding(
                  padding: const .symmetric(horizontal: 16.0),
                  child: Text.rich(
                    textAlign: .center,
                    softWrap: true,
                    TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.error, color: Colors.red, size: 24),
                          alignment: .bottom,
                        ),
                        const TextSpan(
                          text: ' Ошибка: ',
                          style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: .bold),
                        ),
                        TextSpan(
                          text: error,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: .bold),
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