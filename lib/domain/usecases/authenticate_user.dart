import 'package:ballast_machn_test/data/repositories/auth_repository.dart';

class AuthenticateUser {
  final AuthRepository repository;

  AuthenticateUser(this.repository);

  Future<bool> call(String username, String password) async {
    return await repository.authenticate(username, password);
  }
}
