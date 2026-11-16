import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

/// Starter TokoKu Pro. Firebase, background sync, dan push notification
/// ditambahkan pada Hari 3 dan Hari 5 (lihat `main.dart` di materi Hari 5).
void main() {
  runApp(const ProviderScope(child: TokoKuApp()));
}
