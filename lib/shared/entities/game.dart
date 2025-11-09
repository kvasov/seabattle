import 'package:seabattle/shared/entities/ship.dart';

enum GameAction {
  accept,
  cancel,
  ready,
  complete,
}

class GameModel {
  final int id;
  final String? name;
  final List<Ship>? ships;
  final List<Ship>? opponentShips;
  final DateTime createdAt;
  final bool? cancelled;
  final bool? accepted;
  bool ready;
  bool opponentReady;
  final bool? master;

  GameModel({
    required this.id,
    this.name,
    this.ships,
    this.opponentShips,
    required this.createdAt,
    this.cancelled,
    this.accepted,
    this.ready = false,
    this.opponentReady = false,
    this.master,
  });

  GameModel copyWith({
    int? id,
    String? name,
    List<Ship>? ships,
    List<Ship>? opponentShips,
    bool? cancelled,
    bool? accepted,
    bool? ready,
    bool? opponentReady,
    bool? master,
  }) {
    return GameModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ships: ships ?? this.ships,
      opponentShips: opponentShips ?? this.opponentShips,
      createdAt: createdAt,
      cancelled: cancelled ?? this.cancelled,
      accepted: accepted ?? this.accepted,
      ready: ready ?? this.ready,
      opponentReady: opponentReady ?? this.opponentReady,
      master: master ?? this.master,
    );
  }

  factory GameModel.fromDto(GameModelDto dto) {
    return GameModel(id: dto.id, createdAt: dto.createdAt);
  }

  @override
  String toString() {
    return 'GameModel(id: $id, name: $name, ships: $ships, opponentShips: $opponentShips, createdAt: $createdAt, cancelled: $cancelled, accepted: $accepted, ready: $ready, opponentReady: $opponentReady, master: $master)';
  }
}

class GameModelDto {
  final int id;
  final DateTime createdAt;

  GameModelDto({
    required this.id,
    required this.createdAt,
  });
}