import 'package:flutter_riverpod/flutter_riverpod.dart';

// Уникальный id пользователя для WebSocket.
// Чтобы не отправлять сообщение себе.

final userUniqueIdProvider = Provider<String>((ref) => DateTime.now().microsecondsSinceEpoch.toRadixString(16));
