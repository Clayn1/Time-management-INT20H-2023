import 'package:deltaplan/features/sign_up/data/models/auth_response_model.dart';
import 'package:deltaplan/features/sign_up/domain/entities/auth_response.dart';
import 'package:dio/dio.dart';

abstract class SignInDatasource {
  Future<AuthResponse> signIn(String email, String password);
  Future<bool> setFirebaseToken(String token);
  Future<bool> deleteFirebaseToken(String token);
}

class SignInDatasourceImpl implements SignInDatasource {
  final Dio dio;

  SignInDatasourceImpl({required this.dio});

  @override
  Future<AuthResponse> signIn(String email, String password) async {
    final response = await dio
        .post('/auth/login', data: {"email": email, "password": password});
    return AuthResponseModel.fromJson(response.data);
  }

  @override
  Future<bool> setFirebaseToken(String token) async {
    final response = await dio.post('/notification/token?token=$token');
    return true;
  }

  @override
  Future<bool> deleteFirebaseToken(String token) async {
    final response = await dio.delete('/notification/token?token=$token');
    return true;
  }
}
