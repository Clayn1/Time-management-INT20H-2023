import 'package:deltaplan/features/sign_up/domain/entities/auth_response.dart';

class AuthResponseModel extends AuthResponse {
  AuthResponseModel({
    super.errorMessage,
    super.token,
    super.isError,
  });

  AuthResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    isError = json['isError'];
    errorMessage = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['error'] = this.isError;
    data['errorMessage'] = this.errorMessage;
    return data;
  }
}
