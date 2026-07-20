import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url =
      'https://supabase.com/dashboard/project/srmptvqwelrmgkkvhmeu';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNybXB0dnF3ZWxybWdra3ZobWV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQwMjI0MzQsImV4cCI6MjA5OTU5ODQzNH0.75jZVlM2-2Y7Q1ZnwxTQ1hKzueK4f_86FNJ88S8u090';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      // ignore: deprecated_member_use
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
