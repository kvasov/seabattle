import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/core/constants/host.dart';

// Провайдер для Dio с настройками
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.baseUrl = 'http://$host';
  dio.options.connectTimeout = const Duration(milliseconds: 5000);
  dio.options.receiveTimeout = const Duration(milliseconds: 5000);
  dio.options.headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
  return dio;
});
