import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/user.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import 'storage_service.dart';

class ApiService {
  final StorageService _storage = StorageService();

  Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = {'Content-Type': 'application/json'};

    if (auth) {
      final token = await _storage.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  String _extractError(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body['message'] != null) {
        return body['message'] as String;
      }
    } catch (_) {}
    return 'Error en la solicitud (${response.statusCode})';
  }

  Future<User> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/auth/register'),
      headers: await _headers(),
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await _storage.saveToken(data['token'] as String);
      await _storage.saveUserName(data['user']['name'] as String);
      return User.fromJson(data['user']);
    }

    throw Exception(_extractError(response));
  }

  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/auth/login'),
      headers: await _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.saveToken(data['token'] as String);
      await _storage.saveUserName(data['user']['name'] as String);
      return User.fromJson(data['user']);
    }

    throw Exception(_extractError(response));
  }

  Future<List<Category>> getCategories() async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/categories'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Category.fromJson(e)).toList();
    }

    throw Exception(_extractError(response));
  }

  Future<List<Product>> getProducts() async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/products'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    }

    throw Exception(_extractError(response));
  }

  Future<Product> getProductById(int id) async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/products/$id'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    }

    throw Exception(_extractError(response));
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/products/category/$categoryId'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    }

    throw Exception(_extractError(response));
  }

  Future<List<CartItem>> getCart() async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/cart'),
      headers: await _headers(auth: true),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => CartItem.fromJson(e)).toList();
    }

    throw Exception(_extractError(response));
  }

  Future<void> addToCart(int productId, {int quantity = 1}) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/cart'),
      headers: await _headers(auth: true),
      body: jsonEncode({'product_id': productId, 'quantity': quantity}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(_extractError(response));
    }
  }

  Future<void> updateCartItem(int id, int quantity) async {
    final response = await http.put(
      Uri.parse('${AppConstants.baseUrl}/cart/$id'),
      headers: await _headers(auth: true),
      body: jsonEncode({'quantity': quantity}),
    );

    if (response.statusCode != 200) {
      throw Exception(_extractError(response));
    }
  }

  Future<void> removeCartItem(int id) async {
    final response = await http.delete(
      Uri.parse('${AppConstants.baseUrl}/cart/$id'),
      headers: await _headers(auth: true),
    );

    if (response.statusCode != 200) {
      throw Exception(_extractError(response));
    }
  }
}
