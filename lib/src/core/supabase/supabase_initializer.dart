import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Bootstraps Supabase using environment variables.
///
/// Reads SUPABASE_URL and SUPABASE_ANON_KEY from `.env` or compile-time
/// `--dart-define` values. If missing, the app still runs, but data calls
/// will fail until provided.
class SupabaseInitializer {
  static bool _initialized = false;
  static bool get isReady => _initialized;

  static Future<void> ensureInitialized() async {
    if (_initialized) return;

    // Load .env if present (ignored in release builds without the file).
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      if (kDebugMode) {
        debugPrint('Supabase: .env not found, expecting dart-define values.');
      }
    }

    final url =
        dotenv.env['SUPABASE_URL'] ??
        const String.fromEnvironment('SUPABASE_URL', defaultValue: '');
    final anonKey =
        dotenv.env['SUPABASE_ANON_KEY'] ??
        const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

    if (url.isEmpty || anonKey.isEmpty) {
      debugPrint(
        'Supabase: Missing SUPABASE_URL or SUPABASE_ANON_KEY. '
        'Populate .env or pass --dart-define.',
      );
      return;
    }

    await Supabase.initialize(url: url, anonKey: anonKey);
    _initialized = true;
  }

  static SupabaseClient get client => Supabase.instance.client;
}
