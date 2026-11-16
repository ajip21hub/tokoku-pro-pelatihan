# TokoKu Pro — Starter Pelatihan Flutter Lanjutan

Titik awal capstone untuk peserta. Bagian "advanced" (Riverpod 3, jaringan aman, offline-first, testing, produksi) Anda tulis sendiri selama lab Hari 1–5.
Flutter **3.47.x** / Dart **3.13**.

## Isi starter

| Path | Isi |
|---|---|
| `pubspec.yaml` | Semua paket untuk 5 hari. `workspace:` dan `tokoku_core` masih dikomentari (dibuka di Lab Capstone 1) |
| `analysis_options.yaml` | Lint + `riverpod_lint` |
| `config/*.json` | Konfigurasi flavor untuk `--dart-define-from-file` |
| `android/`, `ios/`, `web/` | Flavor `dev`/`prod`, izin manifest, runner Patrol |
| `lib/app.dart`, `lib/main.dart` | App minimal (tema terang/gelap, l10n) yang membuka halaman login |
| `lib/features/auth/presentation/` | UI login dan halaman Profil (belum terhubung ke auth) |
| `lib/core/network/dio_client.dart` | Dio dasar versi Hari 1 (diganti pada Hari 2) |
| `lib/core/settings/` | Preferensi tema (`SharedPreferencesAsync`) |
| `l10n.yaml`, `lib/l10n/app_id.arb` | Teks bahasa Indonesia; bahasa Inggris ditambahkan di Lab 4C |
| `lib/firebase_options.dart` | Placeholder; ditimpa `flutterfire configure` di Hari 5 |
| `tool/order_status_server.dart` | Server WebSocket lokal untuk Lab 3C |
| `lib/**/.gitkeep`, `test/**/.gitkeep` | Struktur folder feature-first yang akan Anda isi |

## Menjalankan

```bash
flutter pub get
dart run build_runner build
flutter test                     # smoke test starter harus lulus
flutter run --flavor dev --dart-define-from-file=config/dev.json
```

Perlu emulator Android, simulator iOS, atau perangkat fisik. Firebase tetap mati sampai Hari 5 (`ENABLE_FIREBASE=false` di `config/dev.json`).

## Checkpoint per hari

Repo peserta punya satu branch per hari. Isinya solusi kumulatif sampai akhir hari itu, dan setiap branch sudah lulus `flutter analyze` dan `flutter test`.

| Branch | Isi |
|---|---|
| `main` | Starter ini (titik awal Lab Capstone 1) |
| `hari-1` | Workspace `tokoku_core`, katalog paginasi, warm-up Riverpod 3 dan Cubit |
| `hari-2` | Auth + refresh token antre, certificate pinning, go_router, detail, pencarian |
| `hari-3` | drift terenkripsi, keranjang offline + sync, background sync, status pesanan WebSocket |
| `hari-4` | Test lengkap, golden, l10n ID/EN, aksesibilitas, Patrol, Pigeon |
| `hari-5` | Firebase, feature flag, AI, CI/CD (capstone lengkap) |

```bash
git fetch origin
git switch hari-2                 # lanjut dari checkpoint bila tertinggal
git diff hari-2 hari-3 --stat     # lihat apa saja yang dikerjakan pada Hari 3
```

Mulai `hari-4`, jalankan `flutter test --update-goldens test/golden` sekali sebelum `flutter test`. Golden platform (font asli) hanya dibuat di mesin Anda dan tidak di-commit.

## Masalah umum

**`Failed to copy plugin ...` / `rsync: mkdir ".../build/ios/SourcePackages/..." failed`** (macOS, Flutter 3.47): folder build iOS untuk Swift Package Manager belum ada. Jalankan:

```bash
mkdir -p build/ios/SourcePackages && flutter pub get
```

Ulangi setelah `flutter clean`. Di Windows dan Linux masalah ini tidak muncul.
