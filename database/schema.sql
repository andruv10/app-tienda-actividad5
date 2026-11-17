-- =============================================================================
-- ARCHIVO: database/schema.sql
-- =============================================================================
--
-- ANALOGÍA: Es el plano de construcción del almacén de la tienda.
-- Define las "estanterías" (tablas) y pone productos de ejemplo para probar.
--
-- ¿Qué hace?
-- - Crea la base de datos ecommerceflutter
-- - Crea 4 tablas: users, categories, products, cart_items
-- - Inserta 4 categorías y 10 productos de prueba
-- - Usa fotografías de producto alojadas en Unsplash
--
-- CÓMO EJECUTAR: Copia todo en MySQL Workbench y presiona el rayo ⚡
--
-- =============================================================================

CREATE DATABASE IF NOT EXISTS ecommerceflutter;
USE ecommerceflutter;

-- ─── TABLA: users ────────────────────────────────────────────────────────────
-- Guarda los usuarios registrados (nombre, email, contraseña encriptada)
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,        -- ID único que se genera solo
  name VARCHAR(100) NOT NULL,               -- Nombre del usuario
  email VARCHAR(150) NOT NULL UNIQUE,       -- Email único (no se puede repetir)
  password VARCHAR(255) NOT NULL,           -- Contraseña encriptada (bcrypt)
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Fecha de registro
);

-- ─── TABLA: categories ───────────────────────────────────────────────────────
-- Tipos de productos: Electrónica, Ropa, Hogar, Deportes
CREATE TABLE IF NOT EXISTS categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(255)
);

-- ─── TABLA: products ─────────────────────────────────────────────────────────
-- Catálogo de productos de la tienda
CREATE TABLE IF NOT EXISTS products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,            -- Precio con 2 decimales
  image_url VARCHAR(255),                   -- URL de la imagen
  category_id INT NOT NULL,                 -- A qué categoría pertenece
  FOREIGN KEY (category_id) REFERENCES categories(id) -- Relación con categories
);

-- ─── TABLA: cart_items ───────────────────────────────────────────────────────
-- Carrito de cada usuario (persistencia en BD, no local)
CREATE TABLE IF NOT EXISTS cart_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,                     -- De qué usuario es el carrito
  product_id INT NOT NULL,                  -- Qué producto lleva
  quantity INT NOT NULL DEFAULT 1,          -- Cuántas unidades
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  UNIQUE KEY unique_user_product (user_id, product_id) -- Un usuario no repite el mismo producto
);

-- ─── DATOS INICIALES: 4 categorías ───────────────────────────────────────────
INSERT INTO categories (name, description) VALUES
('Electrónica', 'Dispositivos y gadgets tecnológicos'),
('Ropa', 'Prendas de vestir para toda ocasión'),
('Hogar', 'Artículos para el hogar'),
('Deportes', 'Equipamiento y accesorios deportivos');

-- ─── DATOS INICIALES: 10 productos ─────────────────────────────────────────────
INSERT INTO products (name, description, price, image_url, category_id) VALUES
('Auriculares Bluetooth', 'Escucha música y atiende llamadas sin cables con estos auriculares Bluetooth. Su cancelación activa de ruido ayuda a reducir sonidos del entorno para concentrarte durante tus trayectos, sesiones de estudio o momentos de descanso.', 49.99, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80', 1),
('Smartwatch', 'Consulta de un vistazo la hora y lleva un registro práctico de tu actividad diaria con este reloj inteligente. Su diseño combina con el uso cotidiano y permite tener funciones útiles siempre a mano, tanto durante el ejercicio como en tus actividades diarias.', 89.99, 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80', 1),
('Camiseta Básica', 'Una prenda versátil para combinar con distintos estilos. Está confeccionada en algodón 100% y tiene un corte clásico cómodo para el día a día; úsala sola en climas cálidos o como capa base debajo de una chaqueta.', 19.99, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=800&q=80', 2),
('Jeans Clásicos', 'Jeans de corte recto pensados para acompañarte en salidas casuales y actividades cotidianas. Su silueta clásica facilita combinarlos con camisetas, camisas o calzado informal para crear conjuntos sencillos y duraderos.', 39.99, 'https://images.unsplash.com/photo-1542272604-787c3835535d?auto=format&fit=crop&w=800&q=80', 2),
('Lámpara LED', 'Ilumina tu escritorio o mesa de trabajo con esta lámpara LED de luz regulable. Ajusta la iluminación según la actividad, desde leer y estudiar hasta realizar tareas que requieren una luz más enfocada.', 24.99, 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=800&q=80', 3),
('Set de Sábanas', 'Renueva la ropa de cama con este juego de sábanas de algodón para colchón tamaño queen. Su tejido está pensado para ofrecer una sensación suave al descansar y facilitar una presentación ordenada y acogedora del dormitorio.', 34.99, 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?auto=format&fit=crop&w=800&q=80', 3),
('Balón de Fútbol', 'Balón de fútbol oficial tamaño 5, cosido a mano para jugar en césped natural o sintético. Es una opción práctica para entrenamientos, partidos recreativos y encuentros con amigos.', 29.99, 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&w=800&q=80', 4),
('Mancuernas 5kg', 'Par de mancuernas de 5 kg cada una para complementar rutinas de fuerza en casa o en el gimnasio. Úsalas en ejercicios de brazos y hombros, o intégralas gradualmente en circuitos de entrenamiento.', 44.99, 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?auto=format&fit=crop&w=800&q=80', 4),
('Tablet 10"', 'Tablet con pantalla de 10 pulgadas para navegar, leer, estudiar y disfrutar de contenido multimedia. Su formato portátil permite llevarla fácilmente entre casa, clases y viajes.', 199.99, 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=800&q=80', 1),
('Chaqueta Deportiva', 'Chaqueta ligera diseñada para acompañarte en entrenamientos y actividades al aire libre. Funciona como una capa cómoda cuando refresca y se puede combinar con ropa deportiva o prendas casuales.', 54.99, 'https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&w=800&q=80', 2);

-- =============================================================================
-- GLOSARIO
-- - PRIMARY KEY: identificador único de cada fila
-- - AUTO_INCREMENT: el ID se genera automáticamente (1, 2, 3...)
-- - FOREIGN KEY: conecta dos tablas (ej: producto → categoría)
-- - ON DELETE CASCADE: si borras un usuario, se borra su carrito también
-- - INSERT: agregar filas de datos a una tabla
-- =============================================================================
