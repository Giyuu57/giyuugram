import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  
  static const String url = 'https://supabase.com/dashboard/project/srmptvqwelrmgkkvhmeu';
  static const String anonKey = 'sb_publishable_ecqDgN-n0jKGapvvI2a7Hw_RpneWJbD';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        eventsPerSecond: 10,
      ),
    );
  }
}

final supabase = Supabase.instance.client;