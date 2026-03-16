import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';
import 'src/core/supabase/supabase_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseInitializer.ensureInitialized();
  runApp(const ProviderScope(child: QuamaaApp()));
}
