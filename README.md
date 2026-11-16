# TokoKu Pro — Capstone Pelatihan Flutter Lanjutan (Advanced)

Kode referensi yang di-*include* langsung ke materi (`../src/*.md`).
Flutter **3.47.9** / Dart **3.13.7**.

## Struktur

| Path | Isi |
|---|---|
| `lib/` | App (feature-first: auth, products, cart, orders, ai, notifications) |
| `packages/tokoku_core/` | Paket murni Dart dalam pub workspace (`Money`) |
| `pigeons/device_api.dart` | Kontrak Pigeon Dart ↔ Kotlin |
| `tool/order_status_server.dart` | Server WebSocket lokal untuk lab Hari 3 |
| `test/`, `patrol_test/`, `integration_test/` | Unit, widget, golden, E2E |
| `config/*.json` | Konfigurasi flavor (`--dart-define-from-file`) |

## Menjalankan

```bash
flutter pub get                       # seluruh workspace
dart run build_runner build
flutter run --flavor dev --dart-define-from-file=config/dev.json

# Lab WebSocket (Hari 3)
dart run tool/order_status_server.dart

# Pigeon (setelah mengubah pigeons/device_api.dart)
dart run pigeon --input pigeons/device_api.dart
```

## Checkpoint per hari

Repo peserta berisi branch `main` (starter) dan `hari-1` sampai `hari-5` (kode ini). Gunakan `git diff hari-2 hari-3` untuk melihat pekerjaan satu hari.

## Cek kualitas

```bash
flutter analyze --fatal-infos         # termasuk riverpod_lint
(cd packages/tokoku_core && flutter test)
flutter test
flutter test --update-goldens test/golden   # hanya jika UI sengaja berubah
patrol test -t patrol_test/app_flow_test.dart --flavor dev   # di device/emulator
```

Firebase (`lib/firebase_options.dart`) masih placeholder: jalankan `flutterfire configure` sebelum memakai `config/dev_firebase.json` / `config/prod.json`.

## Masalah umum

**`Failed to copy plugin ...` / `rsync: mkdir ".../build/ios/SourcePackages/..." failed`** (macOS, Flutter 3.47): folder build iOS untuk Swift Package Manager belum ada. Jalankan:

```bash
mkdir -p build/ios/SourcePackages && flutter pub get
```

Ulangi setelah `flutter clean`. Di Windows dan Linux masalah ini tidak muncul.
