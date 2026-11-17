# Analogía del Backend

Este documento explica **solo** las carpetas y archivos que ves dentro de `backend`.

Imagina que el backend es un **restaurante**.

La app (Flutter) es el **cliente** que pide comida.  
El backend es el **restaurante** que recibe el pedido y responde.

---

## Carpeta `backend`

**Analogía:** El restaurante completo.

Aquí está todo lo necesario para atender a los clientes de la tienda.

---

## Carpeta `config`

**Analogía:** El cable que conecta el restaurante con la bodega.

La bodega es la base de datos (MySQL), donde se guardan usuarios, productos y el carrito.

### Archivo `db.js`

**Analogía:** El enchufe del cable.

Este archivo conecta el servidor con MySQL.  
Sin él, el restaurante no puede buscar ni guardar información.

---

## Carpeta `controllers`

**Analogía:** Los cocineros.

Ellos reciben el pedido, van a buscar lo necesario a la bodega y preparan la respuesta.

### Archivo `authController.js`

**Analogía:** El área de registro de clientes.

Se encarga de:
- Crear una cuenta nueva
- Iniciar sesión

### Archivo `categoryController.js`

**Analogía:** El empleado que muestra las secciones del menú.

Se encarga de mostrar las categorías  
(por ejemplo: Electrónica, Ropa, Hogar, Deportes).

### Archivo `productController.js`

**Analogía:** El encargado del catálogo de productos.

Se encarga de:
- Mostrar todos los productos
- Mostrar un producto
- Filtrar productos por categoría

### Archivo `cartController.js`

**Analogía:** El cajero del carrito.

Se encarga de:
- Ver el carrito
- Agregar productos
- Cambiar cantidades
- Eliminar productos

---

## Carpeta `middlewares`

**Analogía:** El guardia de seguridad.

Antes de entrar a algunas zonas (como el carrito), revisa si el cliente tiene permiso.

### Archivo `authMiddleware.js`

**Analogía:** El guardia que revisa tu pase.

Si el usuario inició sesión correctamente, lo deja pasar.  
Si no, no lo deja entrar.

---

## Carpeta `routes`

**Analogía:** El menú del restaurante.

El menú no cocina. Solo dice:
- qué se puede pedir
- quién lo prepara (qué controller)

### Archivo `authRoutes.js`

**Analogía:** La parte del menú de “cuenta”.

Aquí están los pedidos de:
- Registrarse
- Iniciar sesión

### Archivo `categoryRoutes.js`

**Analogía:** La parte del menú de “categorías”.

Aquí está el pedido para ver las categorías.

### Archivo `productRoutes.js`

**Analogía:** La parte del menú de “productos”.

Aquí están los pedidos para ver productos.

### Archivo `cartRoutes.js`

**Analogía:** La parte VIP del menú: “carrito”.

Aquí están los pedidos del carrito.  
Antes de atender, pasa por el guardia (`authMiddleware.js`).

---

## Carpeta `node_modules`

**Analogía:** La caja de herramientas del restaurante.

Aquí se guardan las herramientas que se instalaron con `npm install`.  
Tú **no programas** dentro de esta carpeta.

---

## Archivo `.env`

**Analogía:** La caja fuerte.

Guarda secretos, como:
- la contraseña de MySQL
- la clave del token de login

No se debe compartir este archivo.

---

## Archivo `index.js`

**Analogía:** La recepción del restaurante.

Este archivo:
- abre el restaurante (enciende el servidor)
- organiza las secciones del menú (`routes`)
- recibe los pedidos de la app

Sin `index.js`, el restaurante no abre.

---

## Resumen muy corto

| Lo que ves | Qué es (en simple) |
|------------|--------------------|
| `config` | Cable a la bodega |
| `db.js` | El enchufe |
| `controllers` | Cocineros |
| `authController.js` | Registro e inicio de sesión |
| `categoryController.js` | Categorías |
| `productController.js` | Productos |
| `cartController.js` | Carrito |
| `middlewares` | Seguridad |
| `authMiddleware.js` | El guardia |
| `routes` | El menú |
| `authRoutes.js` | Pedidos de cuenta |
| `categoryRoutes.js` | Pedidos de categorías |
| `productRoutes.js` | Pedidos de productos |
| `cartRoutes.js` | Pedidos del carrito |
| `node_modules` | Herramientas instaladas |
| `.env` | Caja fuerte |
| `index.js` | Recepción / abre el servidor |

---

## Cómo funciona todo junto (ejemplo)

Cuando un usuario agrega un producto al carrito:

1. La app hace el pedido.
2. `index.js` (recepción) lo recibe.
3. `cartRoutes.js` (menú) dice a quién le toca.
4. `authMiddleware.js` (guardia) revisa el pase.
5. `cartController.js` (cajero) guarda el producto.
6. `db.js` (cable) habla con la base de datos.
7. La app recibe la respuesta: “producto agregado”.

---

**Idea clave:**  
`routes` dice qué pedir.  
`controllers` hacen el trabajo.  
`middlewares` cuidan la seguridad.  
`config` conecta con la base de datos.  
`index.js` abre todo.
