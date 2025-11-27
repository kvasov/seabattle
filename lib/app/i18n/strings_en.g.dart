///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
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
	late final TranslationsEtcEn etc = TranslationsEtcEn._(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn._(_root);
	late final TranslationsSetupshipsEn setupships = TranslationsSetupshipsEn._(_root);
}

// Path: etc
class TranslationsEtcEn {
	TranslationsEtcEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsEtcBottomNavigationBarEn bottomNavigationBar = TranslationsEtcBottomNavigationBarEn._(_root);

	/// en: '(zero) {} (one) {$n hour} (other) {$n hours}'
	String hours({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		zero: '',
		one: '${n} hour',
		other: '${n} hours',
	);

	late final TranslationsEtcLanguageEn language = TranslationsEtcLanguageEn._(_root);
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

// Path: setupships
class TranslationsSetupshipsEn {
	TranslationsSetupshipsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sea Battle: place your ships'
	String get title => 'Sea Battle: place your ships';

	late final TranslationsSetupshipsButtonsEn buttons = TranslationsSetupshipsButtonsEn._(_root);
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
