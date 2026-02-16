import '../models/user.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<AuthResult> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _apiClient.post(
      '/auth/register',
      {
        'email': email,
        'password': password,
        'name': name,
      },
      includeAuth: false,
    );

    final user = User.fromJson(response['user']);
    final token = response['token'];
    await _apiClient.saveToken(token);

    return AuthResult(user: user, token: token);
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/auth/login',
      {
        'email': email,
        'password': password,
      },
      includeAuth: false,
    );

    final user = User.fromJson(response['user']);
    final token = response['token'];
    await _apiClient.saveToken(token);

    return AuthResult(user: user, token: token);
  }

  Future<User> getCurrentUser() async {
    final response = await _apiClient.get('/auth/me');
    return User.fromJson(response['user']);
  }

  Future<void> logout() async {
    await _apiClient.clearToken();
  }
}

class AuthResult {
  final User user;
  final String token;

  AuthResult({required this.user, required this.token});
}
