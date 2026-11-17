# AGENT.md

# Agente de Desarrollo -- E-commerce Flutter + Node.js + MySQL

## Objetivo

Construir una aplicación de e-commerce **completa pero sencilla**,
pensada para estudiantes que disponen únicamente de **5 clases de 1
hora**.

La aplicación debe ser fácil de entender, mantener y explicar.

------------------------------------------------------------------------

# Tecnologías

## Frontend

-   Flutter
-   Dart
-   Provider
-   HTTP
-   SharedPreferences

## Backend

-   Node.js
-   Express
-   MySQL
-   mysql2
-   JWT
-   bcryptjs

------------------------------------------------------------------------

# Funcionalidades

La aplicación únicamente debe incluir:

-   Registro de usuario
-   Inicio de sesión
-   Listado de categorías
-   Listado de productos
-   Filtrar productos por categoría
-   Ver detalle del producto
-   Carrito con persistencia en BD (MySQL Workbench)
-   Cerrar sesión

No implementar:

-   Pagos
-   Inventario
-   Panel administrador
-   Roles
-   Recuperación de contraseña
-   Firebase
-   Docker
-   Prisma
-   Sequelize
-   Clean Architecture
-   Arquitectura Hexagonal
-   DDD
-   Microservicios

------------------------------------------------------------------------

# Arquitectura

Mantener una arquitectura por capas sencilla.

## Backend

backend/ - config/ - controllers/ - middlewares/ - routes/ - index.js

## Frontend

lib/ - core/ - models/ - providers/ - services/ - screens/ - widgets/

------------------------------------------------------------------------

# Base de Datos

Base de datos:

ecommerceflutter

Tablas:

-   users
-   categories
-   products
-   cart_items

Crear y administrar el esquema en **MySQL Workbench**.

## cart_items

Relaciona el carrito de cada usuario con los productos.

Campos sugeridos:

-   id
-   user_id (FK → users)
-   product_id (FK → products)
-   quantity

Insertar datos iniciales:

-   4 categorías
-   10 productos

------------------------------------------------------------------------

# API

Implementar únicamente:

POST /api/auth/register

POST /api/auth/login

GET /api/categories

GET /api/products

GET /api/products/:id

GET /api/products/category/:categoryId

GET /api/cart (requiere JWT)

POST /api/cart (requiere JWT)

PUT /api/cart/:id (requiere JWT)

DELETE /api/cart/:id (requiere JWT)

------------------------------------------------------------------------

# Reglas

1.  Todo el código debe funcionar.
2.  No generar código incompleto.
3.  Crear todos los archivos necesarios.
4.  Explicar cada paso con comentarios.
5.  Mantener nombres claros.
6.  Usar español en la interfaz.
7.  Validar errores básicos.
8.  Antes de continuar comprobar que el proyecto compile.

------------------------------------------------------------------------

# Flujo de desarrollo

## Clase 1

-   Crear backend
-   Configurar Express
-   Crear base de datos en MySQL Workbench (users, categories, products, cart_items)
-   Conectar MySQL

## Clase 2

-   Registro
-   Login
-   JWT
-   bcrypt

## Clase 3

-   Categorías
-   Productos
-   API REST

## Clase 4

-   Flutter
-   Login
-   Registro
-   Consumir API

## Clase 5

-   Home
-   Categorías
-   Productos
-   Carrito (tabla cart_items en Workbench + API)
-   Cierre de sesión

------------------------------------------------------------------------

# Objetivo final

Al finalizar el proyecto, el estudiante deberá tener una aplicación
móvil completamente funcional que permita autenticarse, consultar
productos, gestionar un carrito persistente en MySQL y navegar por una
tienda sencilla utilizando Flutter, Node.js y MySQL.
