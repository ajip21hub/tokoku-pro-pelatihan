import 'package:flutter/material.dart';

/// UI login dari starter (form dan validasi sudah dibahas di materi `day7`).
///
/// Lab 2A (Hari 2): ubah menjadi `ConsumerStatefulWidget`, panggil
/// `authControllerProvider.notifier.login(...)` di `_submit`, tampilkan error
/// dengan `ref.listen`, dan nonaktifkan tombol selama loading.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  // Akun uji dummyjson.com
  final _username = TextEditingController(text: 'emilys');
  final _password = TextEditingController(text: 'emilyspass');

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // TODO(Lab 2A): panggil AuthController.login. Jangan memanggil
    // context.go di sini; router redirect yang memindahkan halaman.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login belum dihubungkan (Lab 2A)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'TokoKu Pro',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  key: const Key('username'),
                  controller: _username,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('password'),
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (v) =>
                      (v == null || v.length < 6) ? 'Min. 6 karakter' : null,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  key: const Key('login-button'),
                  onPressed: _submit,
                  child: const Text('Masuk'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
