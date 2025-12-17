///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  );

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsBattleEn battle = TranslationsBattleEn._(_root);
	late final TranslationsEtcEn etc = TranslationsEtcEn._(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn._(_root);
	late final TranslationsModalsEn modals = TranslationsModalsEn._(_root);
	late final TranslationsQrEn qr = TranslationsQrEn._(_root);
	late final TranslationsSettingsEn settings = TranslationsSettingsEn._(_root);
	late final TranslationsSetupshipsEn setupships = TranslationsSetupshipsEn._(_root);
	late final TranslationsStatisticsEn statistics = TranslationsStatisticsEn._(_root);
}

// Path: battle
class TranslationsBattleEn {
	TranslationsBattleEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cancel game'
	String get cancelGame => 'Cancel game';

	/// en: 'Waiting for opponent...'
	String get waitingForOpponentToBeReady => 'Waiting for opponent...';
}

// Path: etc
class TranslationsEtcEn {
	TranslationsEtcEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsEtcBottomNavigationBarEn bottomNavigationBar = TranslationsEtcBottomNavigationBarEn._(_root);
	late final TranslationsEtcLanguageEn language = TranslationsEtcLanguageEn._(_root);
	late final TranslationsEtcCheaterEn cheater = TranslationsEtcCheaterEn._(_root);
	late final TranslationsEtcDrawerEn drawer = TranslationsEtcDrawerEn._(_root);
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Propose game'
	String get proposeGame => 'Propose game';

	/// en: 'Join game'
	String get joinGame => 'Join game';

	/// en: 'SEA BATTLE'
	String get title => 'SEA BATTLE';

	/// en: 'Settings'
	String get settings => 'Settings';
}

// Path: modals
class TranslationsModalsEn {
	TranslationsModalsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'OK'
	String get modalButtonOk => 'OK';

	/// en: 'You lost :('
	String get loseModalTitle => 'You lost :(';

	/// en: 'You won!'
	String get winModalTitle => 'You won!';

	/// en: 'Cancel game?'
	String get cancelGameModalTitle => 'Cancel game?';

	/// en: 'Are you sure you want to cancel game #$gameId?'
	String cancelGameModalContent({required Object gameId}) => 'Are you sure you want to cancel game #${gameId}?';

	/// en: 'No'
	String get cancelGameModalButtonNo => 'No';

	/// en: 'Yes'
	String get cancelGameModalButtonYes => 'Yes';

	/// en: 'Game canceled by opponent'
	String get canceledGameModalTitle => 'Game canceled by opponent';

	/// en: 'Game already accepted by someone else'
	String get acceptedGameModalTitle => 'Game already accepted by someone else';

	/// en: 'Connection to server interrupted (due to player inactivity or some error)'
	String get webSocketClosedModalTitle => 'Connection to server interrupted (due to player inactivity or some error)';
}

// Path: qr
class TranslationsQrEn {
	TranslationsQrEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Creating game'
	String get creatingGame => 'Creating game';

	/// en: 'Create game'
	String get createGame => 'Create game';

	/// en: 'Accept last game in DB'
	String get acceptLastGame => 'Accept last game in DB';

	/// en: 'Accept game'
	String get acceptGame => 'Accept game';

	/// en: 'Invalid QR code'
	String get invalidQrCode => 'Invalid QR code';

	/// en: 'Scan QR code'
	String get scanQrCode => 'Scan QR code';

	/// en: 'Cancel game'
	String get cancelGame => 'Cancel game';
}

// Path: settings
class TranslationsSettingsEn {
	TranslationsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Go to statistics'
	String get settingsButtonStatistics => 'Go to statistics';

	/// en: 'Use accelerometer'
	String get accelerometerBall => 'Use accelerometer';

	/// en: 'Connected'
	String get bleConnected => 'Connected';

	/// en: 'BLE not connected'
	String get bleNotConnected => 'BLE not connected';

	/// en: 'Click to scan'
	String get bleClickToScan => 'Click to scan';

	/// en: 'Color scheme selection'
	String get colorSchemeSelection => 'Color scheme selection';

	/// en: 'Sound'
	String get sound => 'Sound';

	/// en: 'Dark theme'
	String get darkTheme => 'Dark theme';
}

// Path: setupships
class TranslationsSetupshipsEn {
	TranslationsSetupshipsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sea Battle: place your ships'
	String get title => 'Sea Battle: place your ships';

	late final TranslationsSetupshipsButtonsEn buttons = TranslationsSetupshipsButtonsEn._(_root);
}

// Path: statistics
class TranslationsStatisticsEn {
	TranslationsStatisticsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Statistics'
	String get title => 'Statistics';

	/// en: 'No games played yet'
	String get noGamesPlayedYet => 'No games played yet';

	/// en: 'Hits'
	String get hits => 'Hits';

	/// en: 'Misses'
	String get misses => 'Misses';

	/// en: 'Accuracy'
	String get accuracy => 'Accuracy';

	/// en: 'Losses'
	String get losses => 'Losses';

	/// en: 'Wins'
	String get wins => 'Wins';

	/// en: 'Cancelled'
	String get cancelled => 'Cancelled';

	/// en: 'Total games'
	String get totalGames => 'Total games';

	/// en: 'Total wins'
	String get totalWins => 'Total wins';

	/// en: 'Total losses'
	String get totalLosses => 'Total losses';

	/// en: 'Total cancelled'
	String get totalCancelled => 'Total cancelled';

	/// en: 'Reset statistics'
	String get resetStatistics => 'Reset statistics';
}

// Path: etc.bottomNavigationBar
class TranslationsEtcBottomNavigationBarEn {
	TranslationsEtcBottomNavigationBarEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Home'
	String get home => 'Home';
}

// Path: etc.language
class TranslationsEtcLanguageEn {
	TranslationsEtcLanguageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'English'
	String get en => 'English';

	/// en: 'Russian'
	String get ru => 'Russian';
}

// Path: etc.cheater
class TranslationsEtcCheaterEn {
	TranslationsEtcCheaterEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Congratulations,\nnow you are a cheater'
	String get title => 'Congratulations,\nnow you are a cheater';
}

// Path: etc.drawer
class TranslationsEtcDrawerEn {
	TranslationsEtcDrawerEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sea Battle'
	String get title => 'Sea Battle';
}

// Path: setupships.buttons
class TranslationsSetupshipsButtonsEn {
	TranslationsSetupshipsButtonsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Start game'
	String get startGame => 'Start game';

	/// en: 'Cancel game'
	String get cancelGame => 'Cancel game';
}
