import 'package:dio/dio.dart';
import 'package:teste_flutter/utils/secure_storage.dart';

class ApiService {
  final Dio _dio;

  //url da api
  static const String _baseUrl =
      'http://10.0.2.2:3000/'; // Exemplo para Android Emulator

  // Construtor
  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: Duration(seconds: 5), // Tempo limite para conectar
          receiveTimeout: Duration(
            seconds: 3,
          ), // Tempo limite para receber dados
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          //rotas que não precisam de token
          final noAuthRoutes = ['/auth/login', '/auth/register'];

          if (!noAuthRoutes.contains(options.path)) {
            //demais rotas que usam o token
            final storage = SecureStorage();
            String? token = await storage.getToken();

            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            } else {
              print("Nenhum token encontrado");
            }
          } else {
            print("Rota (${options.path}), token não adicionado");
          }

          return handler.next(options);
        },

        onResponse: (response, handler) {},
        onError: (DioException e, handler) async {
          return handler.next(e);
        },
      ),
    );
  }

  //envio de dados para register
  Future<Response> registerUser(Map<String, dynamic> userData) async {
    try {
      //fazendo a requisição
      Response response = await _dio.post('/auth/register', data: userData);
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        //erro na hora do registro
        return e.response!;
      }

      throw Exception(
        "Falha na comunicação com o servidor ao tentar registrar: ${e.message}",
      );
    } catch (e) {
      throw Exception("ocorreu um erro desconhecido durante o registro: $e");
    }
  }

  //efetuando login
  Future<Response> loginUser(String email, String password) async {
    try {
      final Response response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        //erro na hora do login
        return e.response!;
      }
      throw Exception(
        "Falha na comunicação com o servidor ao tentar fazer login: ${e.message}",
      );
    } catch (e) {
      throw Exception("Ocorreu um erro desconhecido durante o login: $e");
    }
  }

  //criando tarefa
}
