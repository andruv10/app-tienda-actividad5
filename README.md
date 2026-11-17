# App Tienda - E-commerce Flutter + Node.js + MySQL

Aplicación de e-commerce completa para estudiantes.

## Estructura del proyecto

```
appTienda/
├── backend/          # API Node.js + Express
├── database/         # Script SQL para MySQL Workbench
├── lib/              # App Flutter
└── AGENT.md          # Especificación del proyecto
```

## Requisitos

- Node.js 18+
- MySQL 8+
- Flutter 3.x
- MySQL Workbench

## 1. Base de datos (MySQL Workbench)

1. Abre MySQL Workbench y conéctate a tu servidor local.
2. Abre el archivo `database/schema.sql`.
3. Ejecuta todo el script (crea la BD, tablas y datos iniciales).

## 2. Backend

```bash
cd backend
cp .env.example .env
```

Edita `.env` con tu contraseña de MySQL:

```
DB_PASSWORD=tu_password_real
JWT_SECRET=una_clave_secreta_segura
```

Inicia el servidor:

```bash
npm install
npm run dev
```

El API estará en `http://localhost:3000`.

## 3. App Flutter

```bash
flutter pub get
flutter run
```

### URL de la API

- **Windows / iOS simulador:** `http://localhost:3000`
- **Emulador Android:** `http://10.0.2.2:3000` (ya configurado en `lib/core/constants.dart`)

Si usas un dispositivo físico, cambia la IP en `lib/core/constants.dart` por la IP de tu PC en la red local.

## Funcionalidades

- Registro e inicio de sesión (JWT)
- Listado de categorías y productos
- Filtrar por categoría
- Detalle de producto
- Carrito persistente en MySQL
- Cerrar sesión

Las imágenes de productos se cargan desde Unsplash y requieren conexión a internet.
La URL de cada foto se guarda en la columna `image_url` de `products`.

## Endpoints API

| Método | Ruta | Descripción |
|--------|------|-------------|
| POST | /api/auth/register | Registro |
| POST | /api/auth/login | Login |
| GET | /api/categories | Categorías |
| GET | /api/products | Productos |
| GET | /api/products/:id | Detalle producto |
| GET | /api/products/category/:id | Por categoría |
| GET | /api/cart | Carrito (JWT) |
| POST | /api/cart | Agregar al carrito (JWT) |
| PUT | /api/cart/:id | Actualizar cantidad (JWT) |
| DELETE | /api/cart/:id | Eliminar del carrito (JWT) |
