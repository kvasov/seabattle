import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuBtn extends ConsumerWidget {
  const MenuBtn({super.key, required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: .only(
            topRight: .circular(12),
            bottomRight: .circular(12),
          ),
        ),
        child: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          padding: .all(12),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
    );
  }
}