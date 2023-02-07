import 'package:deltaplan/core/error/failures.dart';
import 'package:deltaplan/core/error/repository_request_handler.dart';
import 'package:deltaplan/core/helper/type_aliases.dart';
import 'package:deltaplan/features/sign_up/data/datasource/sign_up_datasourse.dart';
import 'package:deltaplan/features/sign_up/domain/entities/auth_response.dart';
import 'package:deltaplan/features/sign_up/domain/repositories/sign_up_repository.dart';

class SignUpRepositoryImpl implements SignUpRepository {
  final SignUpDatasource datasource;

  SignUpRepositoryImpl({required this.datasource});

  @override
  FutureFailable<AuthResponse> signUp(
      String name, String email, String password) {
    return RepositoryRequestHandler<AuthResponse>()(
      request: () => datasource.signUp(name, email, password),
      defaultFailure: Failure(),
    );
  }
}
