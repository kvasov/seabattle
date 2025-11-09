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
	@override late final _TranslationsEtcRu etc = _TranslationsEtcRu._(_root);
	@override late final _TranslationsHomeRu home = _TranslationsHomeRu._(_root);
	@override late final _TranslationsSetupshipsRu setupships = _TranslationsSetupshipsRu._(_root);
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
}

// Path: home
class _TranslationsHomeRu implements TranslationsHomeEn {
	_TranslationsHomeRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get proposeGame => 'Предложить игру';
	@override String get joinGame => 'Присоединиться к игре';
	@override String get home => 'Главная';
	@override String get settings => 'Настройки';
}

// Path: setupships
class _TranslationsSetupshipsRu implements TranslationsSetupshipsEn {
	_TranslationsSetupshipsRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Морской бой: расставь свои корабли';
	@override late final _TranslationsSetupshipsButtonsRu buttons = _TranslationsSetupshipsButtonsRu._(_root);
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

// Path: setupships.buttons
class _TranslationsSetupshipsButtonsRu implements TranslationsSetupshipsButtonsEn {
	_TranslationsSetupshipsButtonsRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get startGame => 'Начать игру';
	@override String get cancelGame => 'Отменить игру';
}
