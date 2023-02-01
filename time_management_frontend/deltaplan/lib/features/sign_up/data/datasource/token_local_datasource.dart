import 'package:shared_preferences/shared_preferences.dart';

abstract class TokenLocalDatasource {
  Future<bool> saveToken(String jwt);
  Future<bool> deleteToken();
  Future<String?> getToken();
  void init();
}

class TokenLocalDatasourceImpl extends TokenLocalDatasource {
  @override
  void init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  late final SharedPreferences sharedPreferences;

  @override
  Future<bool> saveToken(String jwt) async {
    await sharedPreferences.setString("Authorization", jwt);

    return true;
  }

  @override
  Future<String?> getToken() async {
    final jwt = sharedPreferences.getString("Authorization");

    return jwt;
  }

  @override
  Future<bool> deleteToken() async {
    await sharedPreferences.remove("Authorization");

    return true;
  }
}
