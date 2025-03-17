import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvService {
  static bool loginWithoutGoogle =
      dotenv.env['LOGIN_WITHOUT_GOOGLE']?.toLowerCase() == 'true';

  static String apiUrl = dotenv.env['API_URL'] ?? '';

  static bool skipGoogleSession =
      dotenv.env['SKIP_GOOGLE_SESSION']?.toLowerCase() == 'true';

  static bool registerWithoutGoogle =
      dotenv.env['REGISTER_WITHOUT_GOOGLE']?.toLowerCase() == 'true';
}
