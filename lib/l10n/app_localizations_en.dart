// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get catalogTitle => 'Catalog';

  @override
  String get searchTooltip => 'Search';

  @override
  String get offlineBanner => 'Offline mode: showing saved data';

  @override
  String get retry => 'Try again';

  @override
  String get navCatalog => 'Catalog';

  @override
  String get navCart => 'Cart';

  @override
  String get navProfile => 'Profile';

  @override
  String cartTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items in cart',
      one: '1 item in cart',
      zero: 'Cart is empty',
    );
    return '$_temp0';
  }

  @override
  String get languageLabel => 'Language';
}
