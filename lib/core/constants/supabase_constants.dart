import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConstants {
  static final String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  static final String supabasePublisheableKey = dotenv.env['SUPABASE_PUBLISHEABLE_KEY'] ?? '';
}

