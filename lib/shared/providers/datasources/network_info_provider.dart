import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/core/services/network_info_service.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final networkInfoProvider = Provider<NetworkInfoService>((ref) {
  return NetworkInfoServiceImpl(InternetConnectionChecker.createInstance());
});