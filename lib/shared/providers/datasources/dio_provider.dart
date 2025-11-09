import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Провайдер для Dio с настройками
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.baseUrl = 'http://127.0.0.1:8888';
  dio.options.connectTimeout = const Duration(milliseconds: 5000);
  dio.options.receiveTimeout = const Duration(milliseconds: 5000);
  dio.options.headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
  return dio;
});
