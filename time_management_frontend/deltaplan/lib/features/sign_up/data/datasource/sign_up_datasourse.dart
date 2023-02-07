import 'package:deltaplan/features/sign_up/data/models/auth_response_model.dart';
import 'package:deltaplan/features/sign_up/domain/entities/auth_response.dart';
import 'package:dio/dio.dart';

abstract class SignUpDatasource {
  Future<AuthResponse> signUp(String name, String email, String password);
}

class SignUpDatasourceImpl implements SignUpDatasource {
  final Dio dio;

  SignUpDatasourceImpl({required this.dio});

  @override
  Future<AuthResponse> signUp(
      String name, String email, String password) async {
    final response = await dio.post('/auth/register',
        data: {"email": email, "password": password, "name": name});
    return AuthResponseModel.fromJson(response.data);
  }
}
