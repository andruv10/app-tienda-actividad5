import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<Category> _categories = [];
  List<Product> _products = [];
  Product? _selectedProduct;
  int? _selectedCategoryId;
  bool _isLoading = false;
  String? _error;

  List<Category> get categories => _categories;
  List<Product> get products => _products;
  Product? get selectedProduct => _selectedProduct;
  int? get selectedCategoryId => _selectedCategoryId;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _api.getCategories();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProducts({int? categoryId}) async {
    _isLoading = true;
    _error = null;
    _selectedCategoryId = categoryId;
    notifyListeners();

    try {
      if (categoryId == null) {
        _products = await _api.getProducts();
      } else {
        _products = await _api.getProductsByCategory(categoryId);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Product?> loadProductDetail(int id) async {
    _isLoading = true;
    _error = null;
    _selectedProduct = null;
    notifyListeners();

    try {
      _selectedProduct = await _api.getProductById(id);
      _isLoading = false;
      notifyListeners();
      return _selectedProduct;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void clearSelectedProduct() {
    _selectedProduct = null;
    notifyListeners();
  }
}
