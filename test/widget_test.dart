import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:app_tienda/main.dart';
import 'package:app_tienda/models/product.dart';
import 'package:app_tienda/providers/auth_provider.dart';
import 'package:app_tienda/providers/cart_provider.dart';
import 'package:app_tienda/providers/product_provider.dart';
import 'package:app_tienda/screens/home_screen.dart';
import 'package:app_tienda/screens/login_screen.dart';
import 'package:app_tienda/screens/product_detail_screen.dart';

void main() {
  testWidgets('App carga correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('La búsqueda filtra productos y se puede limpiar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(
            value: _TestAuthProvider(),
          ),
          ChangeNotifierProvider<ProductProvider>.value(
            value: _TestProductProvider([
              _product(1, 'Cafetera Programable'),
              _product(2, 'Audífonos Inalámbricos'),
            ]),
          ),
          ChangeNotifierProvider<CartProvider>.value(
            value: _TestCartProvider(),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cafetera Programable'), findsOneWidget);
    expect(find.text('Audífonos Inalámbricos'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'cafetera');
    await tester.pumpAndSettle();

    expect(find.text('Cafetera Programable'), findsOneWidget);
    expect(find.text('Audífonos Inalámbricos'), findsNothing);

    await tester.enterText(find.byType(TextField), 'sin coincidencias');
    await tester.pumpAndSettle();
    expect(
      find.text('No encontramos productos con ese nombre'),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Audífonos Inalámbricos'), findsOneWidget);
  });

  testWidgets('Al tocar un producto se abre su detalle correspondiente', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1920, 945);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final provider = _TestProductProvider([
      _product(
        1,
        'Cafetera Programable',
        description: 'Cafetera de prueba con temporizador.',
      ),
      _product(
        2,
        'Audífonos Inalámbricos',
        description: 'Audífonos de prueba.',
      ),
    ]);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(
            value: _TestAuthProvider(),
          ),
          ChangeNotifierProvider<ProductProvider>.value(value: provider),
          ChangeNotifierProvider<CartProvider>.value(
            value: _TestCartProvider(),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Cafetera Programable'));
    await tester.tap(find.text('Cafetera Programable'));
    await tester.pumpAndSettle();

    expect(find.text('Detalle del producto'), findsOneWidget);
    expect(find.text('Cafetera Programable'), findsOneWidget);
    final description = find.text('Cafetera de prueba con temporizador.');
    expect(description, findsOneWidget);
    final detailScrollView = find.descendant(
      of: find.byType(ProductDetailScreen),
      matching: find.byType(SingleChildScrollView),
    );
    expect(tester.getSize(detailScrollView).height, greaterThan(0));
    expect(find.text('Audífonos de prueba.'), findsNothing);
    final screenHeight =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    final descriptionTop = tester.getTopLeft(description).dy;
    expect(descriptionTop, greaterThan(56));
    expect(descriptionTop, lessThan(screenHeight - 100));

    await tester.tap(find.text('Agregar al carrito'));
    await tester.pumpAndSettle();
    expect(find.text('Producto agregado al carrito'), findsOneWidget);
  });

  testWidgets('El campo de contraseña permite mostrarla', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>.value(
        value: _TestAuthProvider(),
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();

    final passwordFinder = find.byType(EditableText).last;
    expect(tester.widget<EditableText>(passwordFinder).obscureText, isTrue);

    await tester.tap(find.byTooltip('Mostrar contraseña'));
    await tester.pumpAndSettle();

    expect(tester.widget<EditableText>(passwordFinder).obscureText, isFalse);
  });
}

Product _product(int id, String name, {String? description}) {
  return Product(
    id: id,
    name: name,
    description: description,
    price: 10,
    categoryId: 1,
  );
}

class _TestAuthProvider extends AuthProvider {}

class _TestProductProvider extends ProductProvider {
  _TestProductProvider(this._products);

  final List<Product> _products;

  @override
  List<Product> get products => _products;

  @override
  Future<void> loadCategories() async {}

  @override
  Future<void> loadProducts({int? categoryId}) async {}

  @override
  Future<Product?> loadProductDetail(int id) async {
    return _products.firstWhere((product) => product.id == id);
  }
}

class _TestCartProvider extends CartProvider {
  @override
  Future<void> loadCart() async {}

  @override
  Future<bool> addToCart(int productId, {int quantity = 1}) async => true;
}
