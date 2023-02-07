import 'package:deltaplan/core/helper/type_aliases.dart';
import 'package:deltaplan/features/sign_up/domain/entities/auth_response.dart';

abstract class SignUpRepository {
  FutureFailable<AuthResponse> signUp(
      String name, String email, String password);
}
