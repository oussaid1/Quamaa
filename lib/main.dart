import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/core/supabase/supabase_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseInitializer.ensureInitialized();
  runApp(const QuamaaApp());
}
