import 'package:net_monstrum_card_game/domain/data/user.dart';
import 'package:net_monstrum_card_game/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserSession(String token, DateTime expiryDate) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
  await prefs.setString('expiryDate', expiryDate.toIso8601String());
}

Future<bool> isTokenExpired() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final expiryDateStr = prefs.getString('expiryDate');

  if (token == null || expiryDateStr == null) {
    return true; // No token or expiry date stored, needs to log in
  }

  final expiryDate = DateTime.parse(expiryDateStr);
  if (expiryDate.isBefore(DateTime.now())) {
    return true; // Token is expired
  }

  return false; // Token is still valid
}

class UserFromLocalSession {
  String token = "";
  Map<String, dynamic>? user;
  bool isTokenExpiredOrNotExists = true;

  UserFromLocalSession(this.token, this.user, this.isTokenExpiredOrNotExists);
}

Future<UserFromLocalSession> getUserFromLocalSession() async {
  bool isTokenExpiredOrNotExists = await isTokenExpired();

  if (isTokenExpiredOrNotExists) {
    return UserFromLocalSession("", null, isTokenExpiredOrNotExists);
  }

  UsersService usersService = UsersService();
  // Desencriptar token
  final user = {"email": "email1@gmail.com"};

  final userFromApp =
      await usersService.fetchUserWithGoogleToken("", user["email"]!);

  return UserFromLocalSession("", userFromApp, isTokenExpiredOrNotExists);
}
