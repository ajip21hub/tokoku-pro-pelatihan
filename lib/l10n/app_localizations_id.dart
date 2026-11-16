// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get catalogTitle => 'Katalog';

  @override
  String get searchTooltip => 'Cari';

  @override
  String get offlineBanner => 'Mode offline: menampilkan data tersimpan';

  @override
  String get retry => 'Coba lagi';

  @override
  String get navCatalog => 'Katalog';

  @override
  String get navCart => 'Keranjang';

  @override
  String get navProfile => 'Profil';

  @override
  String cartTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count barang di keranjang',
      zero: 'Keranjang kosong',
    );
    return '$_temp0';
  }

  @override
  String get languageLabel => 'Bahasa';
}
