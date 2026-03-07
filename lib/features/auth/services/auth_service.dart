import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://zara-nonheroical-heath.ngrok-free.dev';

  static String? nombreUsuarioLogueado;

  //LOGIN
  static Future<String?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        nombreUsuarioLogueado = username;
        return data['message'];
      } else {
        print('Error en el login: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error en la conexión: $e');
      return null;
    }
  }

  //REGISTROS
  static Future<bool> register(
    String nombre,
    String username,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre,
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return true; // Registro exitoso
      } else {
        print('Error en el registro: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error en la conexión: $e');
      return false;
    }
  }
}
