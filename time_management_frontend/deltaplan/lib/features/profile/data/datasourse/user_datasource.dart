import 'package:deltaplan/features/profile/data/models/user_model.dart';
import 'package:deltaplan/features/profile/domain/entities/user.dart';
import 'package:dio/dio.dart';

abstract class UserDatasource {
  Future<User> getUser();
}

class UserDatasourceImpl implements UserDatasource {
  final Dio dio;

  UserDatasourceImpl({required this.dio});

  @override
  Future<User> getUser() async {
    final response = await dio.get('/user');
    return UserModel.fromJson(response.data);
  }
}
