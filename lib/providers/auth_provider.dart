import 'package:kfa_mobilenu/api/api_service.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/login_model.dart';
import '../models/user_model.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  ({UserModel user, String token})? build() {
    return null;
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final service = ref.read(apiServiceProvider);
    final request = LoginRequestModel(email: email, password: password);
    final result = await service.login(request);
    if (result.message == "Login Successfully!") {
      final user = await service.getUserByToken(result.token);
      state = (user: user, token: result.token);
      return null;
    } else {
      return result.message;
    }
  }

  Future<String?> logout() async {
    state = null;
    return null;
  }
}
