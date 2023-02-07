class AuthResponse {
  String? token;
  bool? isError;
  String? errorMessage;

  AuthResponse({this.token, this.isError, this.errorMessage});
}
