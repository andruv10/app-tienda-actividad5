import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  final Product? initialProduct;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    this.initialProduct,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _scrollController = ScrollController(keepScrollOffset: false);
  Product? _product;
  bool _isLoading = false;
  bool _isAddingToCart = false;
  String? _error;
  String? _cartMessage;
  bool _cartActionSucceeded = false;

  @override
  void initState() {
    super.initState();
    _product = widget.initialProduct;
    _isLoading = _product == null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProduct();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadProduct() async {
    final provider = context.read<ProductProvider>();
    if (_product == null && mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    final loadedProduct = await provider.loadProductDetail(widget.productId);
    if (!mounted) return;

    setState(() {
      _product = loadedProduct ?? widget.initialProduct;
      _error = loadedProduct == null ? provider.error : null;
      _isLoading = false;
    });
  }

  Future<void> _addToCart() async {
    final cart = context.read<CartProvider>();
    setState(() {
      _isAddingToCart = true;
      _cartMessage = null;
    });

    final success = await cart.addToCart(widget.productId);

    if (!mounted) return;

    setState(() {
      _isAddingToCart = false;
      _cartActionSucceeded = success;
      _cartMessage = success
          ? 'Producto agregado al carrito'
          : (cart.error ?? 'No se pudo agregar el producto. Intenta de nuevo.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = _product;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del producto')),
      body: _isLoading && product == null
          ? const Center(child: CircularProgressIndicator())
          : _error != null && product == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off_rounded, size: 44),
                  const SizedBox(height: 12),
                  Text(_error!),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _loadProduct,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : product == null
          ? const Center(child: Text('No encontramos este producto.'))
          : LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 760;
                final image = ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: SizedBox(
                    height: isWide ? 430 : 300,
                    width: double.infinity,
                    child: product.imageUrl == null
                        ? _imagePlaceholder(context)
                        : Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                _imagePlaceholder(context),
                          ),
                  ),
                );
                final details = _buildProductDetails(context, product);

                return SingleChildScrollView(
                  controller: _scrollController,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1050),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_error != null) ...[
                              _buildFallbackNotice(context),
                              const SizedBox(height: 16),
                            ],
                            if (isWide)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 6, child: image),
                                  const SizedBox(width: 40),
                                  Expanded(flex: 5, child: details),
                                ],
                              )
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  image,
                                  const SizedBox(height: 28),
                                  details,
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: product != null
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.center,
                  heightFactor: 1,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1050),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_cartMessage != null) ...[
                          _buildCartFeedback(context),
                          const SizedBox(height: 10),
                        ],
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isAddingToCart ? null : _addToCart,
                            icon: _isAddingToCart
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.add_shopping_cart_rounded),
                            label: Text(
                              _isAddingToCart
                                  ? 'Agregando...'
                                  : 'Agregar al carrito',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildCartFeedback(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = _cartActionSucceeded
        ? colorScheme.primaryContainer
        : colorScheme.errorContainer;
    final foregroundColor = _cartActionSucceeded
        ? colorScheme.onPrimaryContainer
        : colorScheme.onErrorContainer;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            _cartActionSucceeded
                ? Icons.check_circle_outline_rounded
                : Icons.error_outline_rounded,
            color: foregroundColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _cartMessage!,
              style: TextStyle(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackNotice(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: colorScheme.onErrorContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'No se pudo actualizar el detalle desde el servidor. '
              'Se muestran los datos recibidos en el catálogo.',
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context, Product product) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.categoryName != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              product.categoryName!,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          product.name,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 26),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Descripción del producto',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.description?.trim().isNotEmpty == true
                    ? product.description!
                    : 'Este producto no tiene una descripción disponible.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imagePlaceholder(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 58,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
