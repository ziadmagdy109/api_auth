import 'package:api/data/flutter_secure_storage/flutter_secure_storage.dart';

import 'dio_client.dart';
import 'package:dio/dio.dart';

class AuthService {
  final DioClient _dioClient = DioClient();
  final SecureStorage _storage = SecureStorage();

  Future<bool> login({required String email, required String password}) async {
    try {
      final response = await _dioClient.dio.post(
        '/login', // endpoint
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        if (token != null) {
          await _storage.saveToken(token);
          return true;
        }
      }
      return false;
    } on DioException catch (e) {
      print('Login failed: ${e.response?.data ?? e.message}');
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        '/register',
        data: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Optional: لو في token يخزنه
        final token = response.data['token'];
        if (token != null) {
          await _storage.saveToken(token);
        }

        return true; // رجع true طالما Registration نجح
      }

      return false;
    } on DioException catch (e) {
      print('Register failed: ${e.response?.data}');
      return false;
    }
  }
}
