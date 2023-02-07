import 'package:deltaplan/core/helper/type_aliases.dart';
import 'package:deltaplan/features/profile/domain/entities/user.dart';

abstract class UserRepository {
  FutureFailable<User> getUser();
}
