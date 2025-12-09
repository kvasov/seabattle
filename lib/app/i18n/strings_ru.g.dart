///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsRu implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsRu({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ru,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  );

	/// Metadata for the translations of <ru>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsRu _root = this; // ignore: unused_field

	@override 
	TranslationsRu $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsRu(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsBattleRu battle = _TranslationsBattleRu._(_root);
	@override late final _TranslationsEtcRu etc = _TranslationsEtcRu._(_root);
	@override late final _TranslationsHomeRu home = _TranslationsHomeRu._(_root);
	@override late final _TranslationsModalsRu modals = _TranslationsModalsRu._(_root);
	@override late final _TranslationsQrRu qr = _TranslationsQrRu._(_root);
	@override late final _TranslationsSettingsRu settings = _TranslationsSettingsRu._(_root);
	@override late final _TranslationsSetupshipsRu setupships = _TranslationsSetupshipsRu._(_root);
	@override late final _TranslationsStatisticsRu statistics = _TranslationsStatisticsRu._(_root);
}

// Path: battle
class _TranslationsBattleRu implements TranslationsBattleEn {
	_TranslationsBattleRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get cancelGame => 'Отменить игру';
	@override String get waitingForOpponentToBeReady => 'Ждем соперника...';
}

// Path: etc
class _TranslationsEtcRu implements TranslationsEtcEn {
	_TranslationsEtcRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsEtcBottomNavigationBarRu bottomNavigationBar = _TranslationsEtcBottomNavigationBarRu._(_root);
	@override String hours({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ru'))(n,
		zero: '',
		one: '${n} час',
		few: '${n} часа',
		many: '${n} часов',
	);
	@override late final _TranslationsEtcLanguageRu language = _TranslationsEtcLanguageRu._(_root);
	@override late final _TranslationsEtcCheaterRu cheater = _TranslationsEtcCheaterRu._(_root);
	@override late final _TranslationsEtcDrawerRu drawer = _TranslationsEtcDrawerRu._(_root);
}

// Path: home
class _TranslationsHomeRu implements TranslationsHomeEn {
	_TranslationsHomeRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get proposeGame => 'Предложить игру';
	@override String get joinGame => 'Принять игру';
	@override String get title => 'МОРСКОЙ БОЙ';
	@override String get settings => 'Настройки';
}

// Path: modals
class _TranslationsModalsRu implements TranslationsModalsEn {
	_TranslationsModalsRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get modalButtonOk => 'OK';
	@override String get loseModalTitle => 'Вы проиграли :(';
	@override String get winModalTitle => 'Вы выиграли!';
	@override String get cancelGameModalTitle => 'Отменить игру?';
	@override String cancelGameModalContent({required Object gameId}) => 'Вы уверены, что хотите отменить игру #${gameId}?';
	@override String get cancelGameModalButtonNo => 'Нет';
	@override String get cancelGameModalButtonYes => 'Да';
	@override String get canceledGameModalTitle => 'Игра отменена соперником';
	@override String get acceptedGameModalTitle => 'Игра уже принята кем-то другим';
	@override String get webSocketClosedModalTitle => 'Соединение с сервером прервано (из-за неактивности игрока или какой-то ошибки)';
}

// Path: qr
class _TranslationsQrRu implements TranslationsQrEn {
	_TranslationsQrRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get creatingGame => 'Создание игры';
	@override String get createGame => 'Создать игру';
	@override String get acceptLastGame => 'Принять последнюю игру в БД';
	@override String get acceptGame => 'Принять игру';
	@override String get invalidQrCode => 'Неверный QR-код';
	@override String get scanQrCode => 'Сканирование QR-кода';
	@override String get cancelGame => 'Отменить игру';
}

// Path: settings
class _TranslationsSettingsRu implements TranslationsSettingsEn {
	_TranslationsSettingsRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get settingsButtonStatistics => 'Перейти к статистике';
	@override String get accelerometerBall => 'Использовать акселерометр';
	@override String get bleConnected => 'Подключено';
	@override String get bleNotConnected => 'BLE не подключен';
	@override String get bleClickToScan => 'Нажмите для сканирования';
	@override String get colorSchemeSelection => 'Выбор цветовой схемы';
	@override String get sound => 'Звук';
	@override String get darkTheme => 'Тёмная тема';
}

// Path: setupships
class _TranslationsSetupshipsRu implements TranslationsSetupshipsEn {
	_TranslationsSetupshipsRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Морской бой: расставь свои корабли';
	@override late final _TranslationsSetupshipsButtonsRu buttons = _TranslationsSetupshipsButtonsRu._(_root);
}

// Path: statistics
class _TranslationsStatisticsRu implements TranslationsStatisticsEn {
	_TranslationsStatisticsRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Статистика';
	@override String get noGamesPlayedYet => 'Нет игр';
	@override String get hits => 'Попаданий';
	@override String get misses => 'Промахов';
	@override String get accuracy => 'Точность';
	@override String get losses => 'Поражений';
	@override String get wins => 'Побед';
	@override String get cancelled => 'Отменено';
	@override String get totalGames => 'Игр';
	@override String get totalWins => 'Всего побед';
	@override String get totalLosses => 'Всего поражений';
	@override String get totalCancelled => 'Всего отменено';
	@override String get resetStatistics => 'Сбросить статистику';
}

// Path: etc.bottomNavigationBar
class _TranslationsEtcBottomNavigationBarRu implements TranslationsEtcBottomNavigationBarEn {
	_TranslationsEtcBottomNavigationBarRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Настройки';
	@override String get home => 'Главная';
}

// Path: etc.language
class _TranslationsEtcLanguageRu implements TranslationsEtcLanguageEn {
	_TranslationsEtcLanguageRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get en => 'Английский';
	@override String get ru => 'Русский';
}

// Path: etc.cheater
class _TranslationsEtcCheaterRu implements TranslationsEtcCheaterEn {
	_TranslationsEtcCheaterRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Поздравляем,\nтеперь вы читер';
}

// Path: etc.drawer
class _TranslationsEtcDrawerRu implements TranslationsEtcDrawerEn {
	_TranslationsEtcDrawerRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Морской бой';
}

// Path: setupships.buttons
class _TranslationsSetupshipsButtonsRu implements TranslationsSetupshipsButtonsEn {
	_TranslationsSetupshipsButtonsRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get startGame => 'Начать игру';
	@override String get cancelGame => 'Отменить игру';
}
