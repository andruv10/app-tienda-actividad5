// =============================================================================
// ARCHIVO: controllers/cartController.js
// =============================================================================
//
// ANALOGÍA: Es el cajero que maneja tu carrito de compras.
// Solo atiende a clientes identificados (con token JWT).
// Puede ver tu carrito, agregar productos, cambiar cantidades o eliminar ítems.
//
// ¿Qué hace?
// - getCart: muestra el carrito del usuario logueado
// - addToCart: agrega un producto (o suma cantidad si ya existe)
// - updateCartItem: cambia la cantidad de un ítem
// - removeCartItem: elimina un producto del carrito
//
// =============================================================================

const pool = require('../config/db');

// ─── VER CARRITO ─────────────────────────────────────────────────────────────
async function getCart(req, res) {
  try {
    // req.user.id viene del authMiddleware (usuario del token JWT)
    const userId = req.user.id;

    // Unimos cart_items con products para traer nombre, precio e imagen
    const [items] = await pool.query(`
      SELECT ci.id, ci.quantity, p.id AS product_id, p.name, p.price, p.image_url, p.description
      FROM cart_items ci
      JOIN products p ON ci.product_id = p.id
      WHERE ci.user_id = ?
      ORDER BY ci.id
    `, [userId]);

    res.json(items);
  } catch (error) {
    console.error('Error en getCart:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
}

// ─── AGREGAR AL CARRITO ──────────────────────────────────────────────────────
async function addToCart(req, res) {
  try {
    const userId = req.user.id;
    const { product_id, quantity = 1 } = req.body; // quantity por defecto = 1

    if (!product_id) {
      return res.status(400).json({ message: 'El producto es obligatorio' });
    }

    if (quantity < 1) {
      return res.status(400).json({ message: 'La cantidad debe ser al menos 1' });
    }

    // Verificar que el producto existe
    const [products] = await pool.query('SELECT id FROM products WHERE id = ?', [product_id]);

    if (products.length === 0) {
      return res.status(404).json({ message: 'Producto no encontrado' });
    }

    // ¿El usuario ya tiene este producto en el carrito?
    const [existing] = await pool.query(
      'SELECT id, quantity FROM cart_items WHERE user_id = ? AND product_id = ?',
      [userId, product_id]
    );

    if (existing.length > 0) {
      // Si ya existe, sumamos la cantidad nueva a la anterior
      const newQuantity = existing[0].quantity + quantity;
      await pool.query('UPDATE cart_items SET quantity = ? WHERE id = ?', [newQuantity, existing[0].id]);

      return res.json({ message: 'Cantidad actualizada en el carrito' });
    }

    // Si no existe, insertamos un registro nuevo
    await pool.query(
      'INSERT INTO cart_items (user_id, product_id, quantity) VALUES (?, ?, ?)',
      [userId, product_id, quantity]
    );

    res.status(201).json({ message: 'Producto agregado al carrito' });
  } catch (error) {
    console.error('Error en addToCart:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
}

// ─── ACTUALIZAR CANTIDAD ─────────────────────────────────────────────────────
async function updateCartItem(req, res) {
  try {
    const userId = req.user.id;
    const { id } = req.params;       // ID del ítem en cart_items
    const { quantity } = req.body;

    if (!quantity || quantity < 1) {
      return res.status(400).json({ message: 'La cantidad debe ser al menos 1' });
    }

    // Solo puede editar ítems de SU propio carrito (seguridad)
    const [items] = await pool.query(
      'SELECT id FROM cart_items WHERE id = ? AND user_id = ?',
      [id, userId]
    );

    if (items.length === 0) {
      return res.status(404).json({ message: 'Ítem no encontrado en el carrito' });
    }

    await pool.query('UPDATE cart_items SET quantity = ? WHERE id = ?', [quantity, id]);

    res.json({ message: 'Cantidad actualizada' });
  } catch (error) {
    console.error('Error en updateCartItem:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
}

// ─── ELIMINAR DEL CARRITO ────────────────────────────────────────────────────
async function removeCartItem(req, res) {
  try {
    const userId = req.user.id;
    const { id } = req.params;

    const [result] = await pool.query(
      'DELETE FROM cart_items WHERE id = ? AND user_id = ?',
      [id, userId]
    );

    // affectedRows = cuántas filas se eliminaron (0 = no encontró el ítem)
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Ítem no encontrado en el carrito' });
    }

    res.json({ message: 'Producto eliminado del carrito' });
  } catch (error) {
    console.error('Error en removeCartItem:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
}

module.exports = { getCart, addToCart, updateCartItem, removeCartItem };

// =============================================================================
// GLOSARIO
// - req.user: datos del usuario logueado (viene del middleware JWT)
// - INSERT: agregar fila nueva a una tabla
// - UPDATE: modificar fila existente
// - DELETE: eliminar fila
// - cart_items: tabla que guarda el carrito en la base de datos
// =============================================================================
