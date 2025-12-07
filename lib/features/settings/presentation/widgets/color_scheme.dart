import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/shared/providers/app_theme_provider.dart';
import 'package:seabattle/app/i18n/strings.g.dart';

class ColorSchemeWidget extends ConsumerWidget {
  const ColorSchemeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    final state = ref.watch(appThemeProvider);
    final controller = ref.read(appThemeProvider.notifier);

    final colors = <Color>[
      Colors.teal,
      Colors.blue,
      Colors.purple,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.settings.colorSchemeSelection,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final color in colors)
                  _ColorChoice(
                    color: color,
                    selected: color == state.seedColor,
                    onTap: () => controller.setSeedColor(color),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorChoice extends StatelessWidget {
  const _ColorChoice({required this.color, required this.selected, required this.onTap});

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: selected ? scheme.inverseSurface : scheme.outline, width: selected ? 3 : 1),
        ),
        child: selected
            ? const Icon(
                Icons.check,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}
