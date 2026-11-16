// Warm-up Hari 1: refactor "Grid User dari API" (materi Day 3)
// dari FutureBuilder + http menjadi Riverpod 3 + codegen.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_grid_riverpod.g.dart';

class UserModel {
  UserModel({required this.id, required this.username, required this.city});
  final int id;
  final String username;
  final String city;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as int? ?? 0,
    username: json['username'] as String? ?? '',
    city: (json['address'] as Map<String, dynamic>?)?['city'] as String? ?? '',
  );
}

@riverpod
Future<List<UserModel>> users(Ref ref) async {
  final res = await http.get(Uri.parse('https://fakestoreapi.com/users'));
  if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
  final list = jsonDecode(res.body) as List;
  return list.cast<Map<String, dynamic>>().map(UserModel.fromJson).toList();
}

class UserGridPage extends ConsumerWidget {
  const UserGridPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('User Grid (Riverpod)')),
      body: switch (users) {
        AsyncData(:final value) => RefreshIndicator(
          onRefresh: () => ref.refresh(usersProvider.future),
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: value.length,
            itemBuilder: (_, i) => Card(
              child: Center(
                child: Text(
                  '${value[i].username}\n${value[i].city}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        AsyncError(:final error) => Center(child: Text('Error: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
