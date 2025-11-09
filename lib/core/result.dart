/// Тип-алиас для операций, которые возвращают Result с возможной ошибкой
/// Используется для стандартизации возвращаемых типов в репозиториях и use cases
typedef RequestOperation<T> = Future<Result<T, Failure>>;

/// Sealed класс Result - паттерн для безопасной обработки ошибок
/// Вместо исключений возвращает либо успешный результат, либо ошибку
///
/// Преимущества:
/// - Явная обработка ошибок (no exceptions)
/// - Компилятор заставляет обрабатывать все случаи
/// - Типобезопасность
/// - Функциональный подход к обработке ошибок
sealed class Result<T, E extends Failure> {
  /// Фабричный конструктор для создания успешного результата
  factory Result.ok(T data) => ResultOk(result: data);

  /// Фабричный конструктор для создания результата с ошибкой
  factory Result.error(E error) => ResultError(err: error);

  /// Данные результата (null если ошибка)
  abstract final T? data;

  /// Ошибка (null если успех)
  abstract final E? error;

  /// Проверка на успешность операции
  bool get isSuccess => this is ResultOk<T, E>;

  /// Проверка на наличие ошибки
  bool get isError => this is ResultError<T, E>;
}

/// Класс успешного результата
/// Содержит данные операции и гарантирует отсутствие ошибки
final class ResultOk<T, E extends Failure> implements Result<T, E> {
  ResultOk({required this.result});
  final T result;

  @override
  T get data => result;

  @override
  E? get error => null;

  @override
  bool get isSuccess => true;

  @override
  bool get isError => false;
}

/// Класс результата с ошибкой
/// Содержит информацию об ошибке и гарантирует отсутствие данных
final class ResultError<T, E extends Failure> implements Result<T, E> {
  ResultError({required this.err});
  final E err;

  @override
  E get error => err;

  @override
  T? get data => null;

  @override
  bool get isSuccess => false;

  @override
  bool get isError => true;
}

/// Базовый класс для всех типов ошибок в приложении
/// Позволяет создавать специализированные типы ошибок
class Failure {
  Failure({required this.description});
  final String description;
}
