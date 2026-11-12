import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class PatientApiException implements Exception {
  final String message;
  final int statusCode;

  const PatientApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}

class PatientApi {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000/api',
  );

  static const _timeout = Duration(seconds: 15);

  static Future<Map<String, dynamic>> request(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    late http.Response response;

    try {
      switch (method) {
        case 'POST':
          response = await http
              .post(uri, headers: headers, body: jsonEncode(body ?? {}))
              .timeout(_timeout);
          break;

        case 'PATCH':
          response = await http
              .patch(uri, headers: headers, body: jsonEncode(body ?? {}))
              .timeout(_timeout);
          break;

        default:
          response = await http.get(uri, headers: headers).timeout(_timeout);
      }
    } on TimeoutException {
      throw const PatientApiException('Koneksi server terlalu lama.', 0);
    } catch (_) {
      throw const PatientApiException(
        'Tidak bisa terhubung ke Laravel. '
        'Periksa server dan koneksi USB.',
        0,
      );
    }

    Map<String, dynamic> data;

    try {
      data = Map<String, dynamic>.from(jsonDecode(response.body) as Map);
    } catch (_) {
      throw PatientApiException(
        'Respons server bukan JSON. Periksa Laravel.',
        response.statusCode,
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      var message = data['message']?.toString() ?? 'Permintaan gagal.';

      if (data['errors'] is Map) {
        final errors = data['errors'] as Map;

        if (errors.isNotEmpty) {
          final first = errors.values.first;

          if (first is List && first.isNotEmpty) {
            message = first.first.toString();
          }
        }
      }

      throw PatientApiException(message, response.statusCode);
    }

    return data;
  }

  static Future<Map<String, dynamic>> register({
    required String nik,
    required String name,
    required String birthPlace,
    required String birthDate,
    required String gender,
    required String phone,
    required String address,
    required String province,
    required String city,
    required String district,
    required String village,
  }) {
    return request(
      'POST',
      '/patients/register',
      body: {
        'nik': nik,
        'name': name,
        'birth_place': birthPlace,
        'birth_date': birthDate,
        'gender': gender,
        'phone': phone,
        'address': address,
        'province': province,
        'city': city,
        'district': district,
        'village': village,
      },
    );
  }

  static Future<Map<String, dynamic>> login({
    required String rm,
    required String birthDate,
  }) {
    return request(
      'POST',
      '/patients/login',
      body: {'rm': rm, 'birth_date': birthDate},
    );
  }

  static Future<Map<String, dynamic>> me(String token) {
    return request('GET', '/patients/me', token: token);
  }

  static Future<Map<String, dynamic>> editContact({
    required String token,
    required String phone,
    required String address,
  }) {
    return request(
      'PATCH',
      '/patients/me',
      token: token,
      body: {'phone': phone, 'address': address},
    );
  }

  static Future<void> logout(String token) async {
    await request('POST', '/patients/logout', token: token);
  }
}
