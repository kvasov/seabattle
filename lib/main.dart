import 'package:flutter/material.dart';
import 'package:seabattle/core/services/init.dart' as di;
import 'package:seabattle/shared/providers/app_theme_provider.dart';
import 'package:seabattle/shared/providers/locale_provider.dart';
import 'package:seabattle/app/styles/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seabattle/core/router/app_route_information_parser.dart';
import 'package:seabattle/core/router/app_router_delegate.dart';
import 'package:seabattle/app/i18n/strings.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleSettings.useDeviceLocale();
  await SharedPreferences.getInstance();
  await di.init();

  runApp(
    TranslationProvider(
      child: const ProviderScope(
        child: _App(),
      ),
    ),
  );
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return const MyApp();
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final AppRouterDelegate _routerDelegate;
  late final AppRouteInformationParser _routeParser;

  @override
  void initState() {
    super.initState();
    _routerDelegate = AppRouterDelegate(ref);
    _routeParser = AppRouteInformationParser();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final themeState = ref.watch(appThemeProvider);
    final light = AppTheme.buildLightTheme(themeState.seedColor);
    final dark = AppTheme.buildDarkTheme(themeState.seedColor);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SeaBattle',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeParser,
      locale: locale,
      themeMode: themeState.themeMode,
      theme: light,
      darkTheme: dark,
    );
  }
}
