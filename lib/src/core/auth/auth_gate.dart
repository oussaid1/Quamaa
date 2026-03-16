import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase/supabase_initializer.dart';
import '../../core/theme/theme_controller.dart';
import '../../features/home/home_shell.dart';
import 'auth_providers.dart';

/// Simple gate that shows auth screen when no Supabase session.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ensure Supabase is ready; otherwise show demo HomeShell.
    if (!SupabaseInitializer.isReady) {
      return HomeShell(themeController: themeController);
    }

    final authState = ref.watch(authStateProvider);
    final session = ref.watch(sessionProvider);

    return authState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => AuthScreen(themeController: themeController),
      data: (_) {
        if (session != null && session.user != null) {
          return HomeShell(themeController: themeController);
        }
        return AuthScreen(themeController: themeController);
      },
    );
  }
}

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key, required this.themeController});
  final ThemeController themeController;

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  bool _sending = false;
  String? _message;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendLink() async {
    setState(() {
      _sending = true;
      _message = null;
    });
    try {
      await ref
          .read(authRepositoryProvider)
          .signInWithMagicLink(_emailController.text.trim());
      setState(() {
        _message = 'Check your email for the magic link.';
      });
    } catch (e) {
      setState(() {
        _message = 'Error: $e';
      });
    } finally {
      setState(() {
        _sending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quamaa Sign in'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: widget.themeController.next,
            icon: Icon(switch (widget.themeController.mode) {
              ThemeMode.light => Icons.dark_mode_outlined,
              ThemeMode.dark => Icons.brightness_7_outlined,
              _ => Icons.brightness_auto_outlined,
            }),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _sending ? null : _sendLink,
              child: _sending
                  ? const CircularProgressIndicator()
                  : const Text('Send magic link'),
            ),
            if (_message != null) ...[
              const SizedBox(height: 8),
              Text(_message!),
            ],
          ],
        ),
      ),
    );
  }
}
