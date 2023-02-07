import 'package:deltaplan/core/error/failures.dart';
import 'package:deltaplan/core/error/repository_request_handler.dart';
import 'package:deltaplan/core/helper/type_aliases.dart';
import 'package:deltaplan/features/sign_up/data/datasource/sign_in_datasourse.dart';
import 'package:deltaplan/features/sign_up/domain/entities/auth_response.dart';
import 'package:deltaplan/features/sign_up/domain/repositories/sign_in_repository.dart';

class SignInRepositoryImpl implements SignInRepository {
  final SignInDatasource datasource;

  SignInRepositoryImpl({required this.datasource});

  @override
  FutureFailable<AuthResponse> signIn(String email, String password) {
    return RepositoryRequestHandler<AuthResponse>()(
      request: () => datasource.signIn(email, password),
      defaultFailure: Failure(),
    );
  }

  @override
  FutureFailable<bool> setFirebaseToken(String token) {
    return RepositoryRequestHandler<bool>()(
      request: () => datasource.setFirebaseToken(token),
      defaultFailure: Failure(),
    );
  }

  @override
  FutureFailable<bool> deleteFirebaseToken(String token) {
    return RepositoryRequestHandler<bool>()(
      request: () => datasource.deleteFirebaseToken(token),
      defaultFailure: Failure(),
    );
  }
}
