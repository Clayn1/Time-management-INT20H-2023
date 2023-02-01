import 'package:deltaplan/features/sign_up/domain/repositories/token_local_repository.dart';
import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  TokenInterceptor({
    required this.tokenLocalRepository,
  });

  final TokenLocalRepository tokenLocalRepository;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await tokenLocalRepository.getToken();
    token.fold(
      (failure) => null, // throw GetTokenException(),
      (data) => {
        if (options.headers.containsKey('Authorization'))
          {options.headers['Authorization'] = 'Bearer $data'}
        else
          {
            options.headers.putIfAbsent('Authorization', () => 'Bearer $data'),
          }
      },
    );
    super.onRequest(options, handler);
  }
}
