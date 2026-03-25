import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../application/state/zimo_store.dart';
import '../../domain/entities/owner_property.dart';
import '../../domain/entities/user_profile.dart';
import '../exceptions/auth_exception.dart';

class BackendService {
  BackendService._();

  static final BackendService instance = BackendService._();
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );
  static const Duration _requestTimeout = Duration(seconds: 12);

  Future<void> registerUser(UserProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 400));
    ZimoStore.instance.addUser(profile);
  }

  Future<UserProfile?> loginUser(String email, String password) async {
    final uri = Uri.parse('$baseUrl/api/login.php');
    try {
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(_requestTimeout);

      final Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 || json['ok'] != true) {
        throw AuthException(
          json['message']?.toString() ?? 'Falha ao autenticar no backend.',
        );
      }

      final user = UserProfile.fromApi(json['user'] as Map<String, dynamic>);
      ZimoStore.instance.setCurrentUser(user);
      return user;
    } on TimeoutException {
      throw AuthException(
        'O servidor demorou para responder. Verifique a ligacao e tente novamente.',
      );
    } on AuthException {
      rethrow;
    } catch (_) {
      throw AuthException(
        'Nao foi possivel conectar ao backend. Confirme se o servidor esta ativo.',
      );
    }
  }

  Future<List<UserProfile>> fetchUsers() async {
    final uri = Uri.parse('$baseUrl/api/users.php');
    try {
      final response = await http.get(uri).timeout(_requestTimeout);
      final Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 || json['ok'] != true) {
        throw AuthException(
          json['message']?.toString() ?? 'Falha ao carregar usuarios.',
        );
      }

      final rawUsers = (json['users'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(UserProfile.fromApi)
          .toList();

      ZimoStore.instance.setUsers(rawUsers);
      return rawUsers;
    } on TimeoutException {
      throw AuthException(
        'O servidor demorou para responder. Tente novamente em instantes.',
      );
    } on AuthException {
      rethrow;
    } catch (_) {
      throw AuthException(
        'Nao foi possivel carregar os usuarios. Verifique o backend.',
      );
    }
  }

  Future<List<OwnerProperty>> fetchOwnerProperties(String ownerId) async {
    final uri = Uri.parse('$baseUrl/api/properties.php?owner_id=$ownerId');
    try {
      final response = await http.get(uri).timeout(_requestTimeout);
      final Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 || json['ok'] != true) {
        throw AuthException(
          json['message']?.toString() ?? 'Falha ao carregar imoveis.',
        );
      }

      final rows = (json['properties'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();
      return rows.map(OwnerProperty.fromApi).toList();
    } on TimeoutException {
      throw AuthException(
        'O servidor demorou para responder. Tente novamente em instantes.',
      );
    } on AuthException {
      rethrow;
    } catch (_) {
      throw AuthException(
        'Nao foi possivel carregar os imoveis. Verifique o backend.',
      );
    }
  }

  Future<List<OwnerProperty>> fetchAvailableProperties({
    String? type,
    String? location,
    double? maxPrice,
  }) async {
    final query = <String, String>{};
    if (type != null && type.trim().isNotEmpty && type != 'Todos') {
      query['type'] = type.trim();
    }
    if (location != null && location.trim().isNotEmpty) {
      query['location'] = location.trim();
    }
    if (maxPrice != null && maxPrice > 0) {
      query['max_price'] = maxPrice.toStringAsFixed(0);
    }

    final uri =
        Uri.parse('$baseUrl/api/properties.php').replace(queryParameters: query);
    try {
      final response = await http.get(uri).timeout(_requestTimeout);
      final Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200 || json['ok'] != true) {
        throw AuthException(
          json['message']?.toString() ?? 'Falha ao carregar imoveis.',
        );
      }
      final rows = (json['properties'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();
      return rows.map(OwnerProperty.fromApi).toList();
    } on TimeoutException {
      throw AuthException(
        'O servidor demorou para responder. Tente novamente em instantes.',
      );
    } on AuthException {
      rethrow;
    } catch (_) {
      throw AuthException(
        'Nao foi possivel carregar os imoveis disponiveis.',
      );
    }
  }

  Future<OwnerProperty> createProperty({
    required String ownerId,
    required String name,
    required String propertyType,
    required int bedrooms,
    required String address,
    required String rent,
    required String description,
    required List<XFile> photos,
  }) async {
    final uri = Uri.parse('$baseUrl/api/properties.php');
    try {
      final request = http.MultipartRequest('POST', uri)
        ..fields['owner_id'] = ownerId
        ..fields['name'] = name
        ..fields['property_type'] = propertyType
        ..fields['bedrooms'] = bedrooms.toString()
        ..fields['address'] = address
        ..fields['rent'] = rent
        ..fields['description'] = description;

      for (final photo in photos) {
        request.files.add(
          await http.MultipartFile.fromPath('photos[]', photo.path),
        );
      }

      final streamed = await request.send().timeout(_requestTimeout);
      final response = await http.Response.fromStream(streamed);
      final Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 201 || json['ok'] != true) {
        throw AuthException(
          json['message']?.toString() ?? 'Falha ao cadastrar imovel.',
        );
      }

      return OwnerProperty.fromApi(json['property'] as Map<String, dynamic>);
    } on TimeoutException {
      throw AuthException(
        'O servidor demorou para responder. Tente novamente em instantes.',
      );
    } on AuthException {
      rethrow;
    } catch (_) {
      throw AuthException(
        'Nao foi possivel salvar o imovel. Verifique o backend.',
      );
    }
  }
}
