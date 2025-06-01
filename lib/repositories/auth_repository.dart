import 'package:dio/dio.dart';
import 'package:teste_flutter/utils/secure_storage.dart';
import '../services/api_service.dart'; // Seu ApiService

class AuthRepository {
  final ApiService _apiService;
  final SecureStorage _secureStorage;

  // O ApiService pode ser injetado ou instanciado aqui
  AuthRepository({ApiService? apiService, SecureStorage? secureStorage})
    : _apiService = apiService ?? ApiService(),
      _secureStorage = secureStorage ?? SecureStorage();

  /// Tenta registrar um usuário.
  /// Retorna uma mensagem de erro em caso de falha, ou null em caso de sucesso.
  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> userData = {
        "name": name,
        "email": email,
        "password": password,
      };

      final Response response = await _apiService.registerUser(userData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Sucesso, usuário registrado!
        return null;
      } else {
        // Erro da API
        String errorMessage = "Erro desconhecido no cadastro.";
        if (response.data is Map && response.data['message'] != null) {
          errorMessage = response.data['message'];
        } else if (response.data != null) {
          errorMessage = response.data.toString();
        }
        return errorMessage; // Retorna a mensagem de erro
      }
    } on DioException catch (e) {
      // Erro específico do Dio
      String errorMessage = "Falha na comunicação com o servidor.";
      if (e.response?.data is Map && e.response?.data['message'] != null) {
        errorMessage = e.response!.data['message'];
      } else if (e.message != null && e.message!.isNotEmpty) {
        errorMessage = e.message!;
      }
      return errorMessage;
    } catch (e) {
      // Outro tipo de erro inesperado
      return 'Ocorreu um erro inesperado: ${e.toString()}';
    }
  }

  //realizando o login
  Future<Map<String, dynamic>> loginUser({
    // Adicionado 'required' que estava na sua definição original
    required String email,
    required String password,
  }) async {
    try {
      final Response response = await _apiService.loginUser(email, password);

      // Se retornar 200 (deu certo)
      if (response.statusCode == 200) {
        // Pegar o token retornado pelo servidor
        if (response.data is Map && response.data['token'] != null) {
          String token = response.data['token'];
          // Salvando no secure storage
          await _secureStorage.saveToken(token);

          return {
            'success': true,
            'token': token,
          }; // Retorna o token em caso de sucesso
        } else {
          // Status 200, mas o token não veio como esperado na resposta.

          return {
            'error': 'Resposta inesperada do servidor após login bem-sucedido.',
          };
        }
      } else {
        String errorMessage = "Credenciais inválidas ou usuário não encontrado";

        if (response.data is Map && response.data['error'] != null) {
          errorMessage = response.data['error'];
        } else if (response.data is Map && response.data['error'] != null) {
          errorMessage = response.data['error'];
        }
        // caso a API não envie um corpo de erro com 'error' ou 'message'.
        return {'error': errorMessage}; // Retorna o erro
      }
    } on DioException catch (e) {
      String errorMessage = "Falha na comunicação (DioException)";
      if (e.response?.data is Map) {
        if (e.response!.data['error'] != null) {
          errorMessage = e.response!.data['error'];
        } else if (e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        }
      } else if (e.message != null && e.message!.isNotEmpty) {
        errorMessage = e.message!;
      }

      //erro do Dio na hora do login
      return {'error': errorMessage}; // Retorna o erro
    } catch (e) {
      //algum erro desconhecido no Dio
      return {'error': 'Erro inesperado: ${e.toString()}'}; // Retorna o erro
    }
  }
}
