import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tokoku_core/tokoku_core.dart';

part 'cart_providers.g.dart';

// STUB Hari 2: router dan nav bar sudah merujuk provider ini.
// Versi asli (drift + sync) dibuat pada Lab 3B.
@riverpod
({int count, Money total}) cartSummary(Ref ref) =>
    (count: 0, total: Money.zero(.usd));
