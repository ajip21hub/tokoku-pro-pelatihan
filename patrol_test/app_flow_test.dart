import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:patrol/patrol.dart';
import 'package:tokoku_pro/app.dart';

/// Jalankan di emulator/device:
///   patrol test -t patrol_test/app_flow_test.dart --flavor dev \
///     --dart-define-from-file=config/dev.json
void main() {
  patrolTest('login -> detail -> keranjang -> checkout -> status pesanan', (
    $,
  ) async {
    await $.pumpWidgetAndSettle(const ProviderScope(child: TokoKuApp()));

    // Dialog izin NATIVE (bukan widget Flutter) -> hanya bisa lewat Patrol.
    if (await $.platform.mobile.isPermissionDialogVisible()) {
      await $.platform.mobile.grantPermissionWhenInUse();
    }

    // clearPackageData=true -> setiap test mulai dari kondisi belum login.
    await $(const Key('login-button')).tap();
    await $('Katalog').waitUntilVisible();

    await $(Card).at(0).tap();
    await $('Tambah ke Keranjang').tap();
    await $('Ditambahkan ke keranjang').waitUntilVisible();

    await $.tester.pageBack();
    await $('Keranjang').tap();
    await $(const Key('checkout-button')).tap();
    await $('Pesanan dibuat').waitUntilVisible();
  });
}
