import 'package:deltaplan/core/error/failures.dart';
import 'package:deltaplan/core/error/repository_request_handler.dart';
import 'package:deltaplan/core/helper/type_aliases.dart';
import 'package:deltaplan/features/profile/data/datasourse/user_datasource.dart';
import 'package:deltaplan/features/profile/domain/entities/user.dart';
import 'package:deltaplan/features/profile/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDatasource datasource;

  UserRepositoryImpl({required this.datasource});

  @override
  FutureFailable<User> getUser() {
    return RepositoryRequestHandler<User>()(
      request: () => datasource.getUser(),
      defaultFailure: Failure(),
    );
  }
}
