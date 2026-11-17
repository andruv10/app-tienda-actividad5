# Tutorial: Construir la App Tienda desde cero

Esta guía es para estudiantes que **nunca han programado**.  
Aquí aprenderás **en qué orden crear cada archivo** y **qué hace cada parte**.

> **Importante:** No necesitas escribir el código de memoria.  
> En cada paso te diremos: *"Copia el mismo código que está en el archivo X del proyecto"*.  
> Tu trabajo es **entender el orden**, **crear la carpeta/archivo** y **pegar el código correcto**.

> **Para ejecutar la app** cuando termines cada clase, usa la guía `ejecutar.md`.

---

## Cómo usar la terminal (léelo antes de la Clase 1)

La **terminal** es una ventana donde escribes comandos de texto.  
En este tutorial **no te saltes ningún comando de terminal**.

### Abrir la terminal en Cursor

1. Menú **Terminal → Nueva terminal** (o tecla `` Ctrl + ` ``).
2. Verás una línea que termina con algo como `PS C:\...\appTienda>`.
3. Esa línea es donde escribes los comandos y presionas **Enter**.

### Comandos básicos que usarás

| Comando | Qué hace |
|---------|----------|
| `cd nombre_carpeta` | Entrar a una carpeta |
| `cd ..` | Salir a la carpeta anterior |
| `cd backend` | Entrar a la carpeta del servidor |
| `copy archivo1 archivo2` | Copiar un archivo (Windows) |
| `npm install` | Preparar el proyecto Node.js |
| `npm install express` | Instalar la librería Express (ejemplo) |
| `npm install express mysql2 cors dotenv bcryptjs jsonwebtoken` | Instalar todas las librerías del backend |
| `npm run dev` | Encender el servidor |
| `flutter pub get` | Descargar librerías de Flutter |
| `flutter run -d chrome` | Abrir la app en Chrome |

### Regla de las dos terminales (desde la Clase 4)

Cuando uses la app Flutter necesitarás **2 terminales abiertas al mismo tiempo**:

| Terminal | Carpeta | Comando | ¿Cerrar? |
|----------|---------|---------|----------|
| Terminal 1 | `backend` | `npm run dev` | **No** — déjala abierta |
| Terminal 2 | `appTienda` (raíz) | `flutter run -d chrome` | Cierra con `q` + Enter |

### Si la ruta de tu proyecto es diferente

En los ejemplos usamos esta ruta. **Cambia solo si tu carpeta está en otro lugar:**

```
cd "C:\Users\johan\Documents\SALLE\2026-2\Computación Móvil\appTienda"
```

---

## Antes de empezar

### ¿Qué vas a construir?

Una tienda online con:
- Registro e inicio de sesión
- Lista de productos y categorías
- Detalle de producto
- Carrito guardado en la base de datos

### Las 3 capas (muy importante)

```
Flutter (lo que ves)  →  Backend (servidor)  →  MySQL (base de datos)
```

**Siempre construimos en este orden:**
1. Primero la base de datos
2. Luego el backend
3. Al final la app Flutter

---

## Mapa general: orden de todos los archivos

Usa esta lista como referencia. No te adelantes a los pasos de una clase futura.

| # | Archivo | ¿Qué es? |
|---|---------|----------|
| 1 | `database/schema.sql` | Crea tablas y datos de ejemplo |
| 2 | `backend/package.json` | Lista las librerías del servidor |
| 3 | `backend/.env` | Contraseña de MySQL (copia de `.env.example`) |
| 4 | `backend/config/db.js` | Conexión a MySQL |
| 5 | `backend/middlewares/authMiddleware.js` | Verifica que el usuario esté logueado |
| 6 | `backend/controllers/authController.js` | Registro y login |
| 7 | `backend/routes/authRoutes.js` | Rutas de registro y login |
| 8 | `backend/controllers/categoryController.js` | Lista categorías |
| 9 | `backend/routes/categoryRoutes.js` | Ruta GET /categories |
| 10 | `backend/controllers/productController.js` | Lista y filtra productos |
| 11 | `backend/routes/productRoutes.js` | Rutas de productos |
| 12 | `backend/controllers/cartController.js` | Carrito en la BD |
| 13 | `backend/routes/cartRoutes.js` | Rutas del carrito |
| 14 | `backend/index.js` | Arranca el servidor |
| 15 | `pubspec.yaml` | Dependencias de Flutter |
| 16 | `lib/core/constants.dart` + archivos `app_url*` | URL del servidor |
| 17 | `lib/models/*.dart` | Forma de los datos (usuario, producto, etc.) |
| 18 | `lib/services/storage_service.dart` | Guarda el token en el celular/navegador |
| 19 | `lib/services/api_service.dart` | Llama al servidor |
| 20 | `lib/providers/*.dart` | Estado de la app (login, productos, carrito) |
| 21 | `lib/widgets/*.dart` | Piezas reutilizables de la interfaz |
| 22 | `lib/screens/*.dart` | Pantallas completas |
| 23 | `lib/main.dart` | Punto de entrada de la app |

---

# CLASE 1 — Base de datos y servidor básico

**Objetivo de hoy:** Tener MySQL con datos y un servidor que responda "funcionando".

---

## Paso 1.1 — Crear la base de datos

### Qué hacer
1. Abre **MySQL Workbench** (ver `ejecutar.md` si no sabes cómo).
2. En el proyecto, abre el archivo `database/schema.sql`.
3. Copia **todo** el contenido (`Ctrl + A`, `Ctrl + C`).
4. Pégalo en Workbench y ejecuta con el rayo ⚡.

### Qué aprendiste
- Una **base de datos** guarda información en **tablas** (como hojas de Excel).
- `users` = usuarios registrados
- `categories` = tipos de productos (Electrónica, Ropa…)
- `products` = productos de la tienda
- `cart_items` = lo que cada usuario tiene en el carrito

### Cómo comprobar
En Workbench, refresca el panel izquierdo y debe aparecer `ecommerceflutter` con sus 4 tablas.

---

## Paso 1.2 — Crear la carpeta del backend

### Qué hacer
1. En la raíz del proyecto (`appTienda`), crea la carpeta `backend`.
2. Dentro de `backend`, crea estas carpetas vacías:
   - `config`
   - `controllers`
   - `middlewares`
   - `routes`

### Qué aprendiste
- El **backend** es el "cerebro" que habla con la base de datos.
- Separamos el código en carpetas para no mezclar todo.

---

## Paso 1.3 — Archivo `package.json`

### Qué hacer
1. Dentro de `backend`, crea el archivo `package.json`.
2. Abre el `package.json` que ya viene en el proyecto.
3. Copia todo y pégalo en tu archivo.

### Qué hace este archivo
Le dice a Node.js qué librerías necesita el servidor:

| Librería | Para qué sirve |
|----------|----------------|
| `express` | Crea el servidor web |
| `mysql2` | Conecta con MySQL |
| `cors` | Permite que Flutter se conecte al servidor |
| `dotenv` | Lee el archivo `.env` (contraseñas) |
| `bcryptjs` | Encripta contraseñas (login/registro) |
| `jsonwebtoken` | Crea el token JWT al iniciar sesión |

---

### Paso B — Abrir la terminal

1. En Cursor, ve a **Terminal → Nueva terminal** (o presiona `` Ctrl + ` ``).
2. Se abrirá una ventana abajo con una línea donde puedes escribir.

---

### Paso C — Entrar a la carpeta `backend`

Escribe **un comando a la vez**. Presiona **Enter** después de cada uno.

**Comando 1** — Ir a la carpeta del proyecto (solo si no estás ahí):

```
cd "C:\Users\johan\Documents\SALLE\2026-2\Computación Móvil\appTienda"
```

**Comando 2** — Entrar al backend:

```
cd backend
```

La terminal debe mostrar algo como:

```
PS C:\...\appTienda\backend>
```

Si ves `\backend>` al final, estás en el lugar correcto.

---

### Paso D — Instalar Node.js en el proyecto (`npm install`)

Con la terminal **dentro de `backend`**, escribe:

```
npm install
```

Presiona Enter y espera. Esto prepara el proyecto y lee el `package.json`.

---

### Paso E — Instalar cada librería (una por una)

Ahora instala **cada librería** con su propio comando.  
Escribe uno, presiona Enter, espera a que termine, y luego el siguiente:

**Comando 3 — Express** (crea el servidor web):

```
npm install express
```

**Comando 4 — MySQL2** (conecta con la base de datos):

```
npm install mysql2
```

**Comando 5 — CORS** (permite que Flutter se conecte):

```
npm install cors
```

**Comando 6 — dotenv** (lee el archivo `.env`):

```
npm install dotenv
```

**Comando 7 — bcryptjs** (encripta contraseñas):

```
npm install bcryptjs
```

**Comando 8 — jsonwebtoken** (crea el token de login):

```
npm install jsonwebtoken
```

---

### Paso F — Instalar todo junto (alternativa más rápida)

Si prefieres, en lugar de los comandos 3 al 8, puedes instalar **todas las librerías en un solo comando**:

```
npm install express mysql2 cors dotenv bcryptjs jsonwebtoken
```

Hace lo mismo que instalar una por una, pero más rápido.

---

### Paso G — Comprobar que todo se instaló bien

Después de instalar, verifica:

1. **No debe haber errores en rojo** en la terminal.
2. Debe aparecer algo como `added XX packages`.
3. En la carpeta `backend` debe existir la carpeta `node_modules` (no la borres).
4. Abre `backend/package.json` y verifica que en `dependencies` aparezcan las 6 librerías.

**Resumen de comandos en orden (copia esta lista):**

```
cd "C:\Users\johan\Documents\SALLE\2026-2\Computación Móvil\appTienda"
cd backend
npm install
npm install express
npm install mysql2
npm install cors
npm install dotenv
npm install bcryptjs
npm install jsonwebtoken
```

> **Importante:** Siempre que agregues una librería nueva al proyecto, vuelve a `cd backend` y ejecuta `npm install nombre_libreria`.

---

## Paso 1.4 — Archivo `.env`

### Qué hacer (en el editor)
1. En `backend`, copia el archivo `.env.example`.
2. Renómbralo a `.env` (sin "example").
3. Abre `.env` y cambia `DB_PASSWORD` por tu contraseña real de MySQL.

### Qué hacer (en la terminal)

Si prefieres hacerlo por terminal, con la terminal en la carpeta `backend`:

```
cd backend
```

(Si ya estás en `backend`, no hace falta repetir el `cd`.)

Luego copia el archivo:

```
copy .env.example .env
```

Después abre `.env` en el editor y cambia la contraseña.

### Qué aprendiste
- `.env` guarda datos secretos (contraseñas).
- **Nunca** compartas tu `.env` con nadie.

---

## Paso 1.5 — Archivo `config/db.js`

### Qué hacer
1. Crea `backend/config/db.js`.
2. Copia el código desde el archivo `backend/config/db.js` del proyecto.

### Qué hace
Crea la **conexión** entre Node.js y MySQL. Es como el "cable" que une el servidor con la base de datos.

---

## Paso 1.6 — Archivo `index.js` (servidor mínimo)

### Qué hacer
1. Crea `backend/index.js`.
2. Por ahora copia solo la parte básica del `index.js` del proyecto, **o** copia el archivo completo (funcionará igual).

Si quieres ir paso a paso, el servidor mínimo debe:
- Importar `express` y `cors`
- Escuchar en el puerto 3000
- Responder en `/` con un mensaje JSON

Luego, en la Clase 2 y 3, irás agregando las rutas.

> **Recomendación:** Copia el `backend/index.js` completo del proyecto. Las rutas que aún no existan las crearás en las siguientes clases.

---

### Paso A — Encender el servidor (terminal)

1. Abre la terminal (o usa la que ya tienes).
2. Ve a la carpeta del proyecto:

```
cd "C:\Users\johan\Documents\SALLE\2026-2\Computación Móvil\appTienda"
```

3. Entra al backend:

```
cd backend
```

4. Enciende el servidor:

```
npm run dev
```

5. Debes ver este mensaje:

```
Servidor corriendo en http://localhost:3000
```

**No cierres esta terminal.** El servidor debe quedarse encendido.

---

### Paso B — Probar en el navegador

1. Abre **Google Chrome**.
2. En la barra de direcciones escribe:

```
http://localhost:3000
```

3. Debes ver:

```
{"message":"API E-commerce funcionando"}
```

### Si algo falla

| Error | Qué revisar |
|-------|-------------|
| `npm no se reconoce` | Instala Node.js y reinicia la PC |
| `Access denied` (MySQL) | Revisa la contraseña en `backend/.env` |
| El puerto está ocupado | Cierra otras terminales con `Ctrl + C` y vuelve a intentar |

**¡Clase 1 terminada!** Tienes base de datos + servidor encendido.

---

# CLASE 2 — Registro, login y seguridad (JWT)

**Objetivo de hoy:** Que un usuario pueda registrarse e iniciar sesión.

---

## Paso 2.1 — ¿Qué es JWT y bcrypt? (concepto)

Antes de programar, entiende esto:

| Término | Explicación simple |
|---------|-------------------|
| **Registro** | Guardar un usuario nuevo en la tabla `users` |
| **Login** | Verificar email y contraseña |
| **bcrypt** | Encripta la contraseña (nunca se guarda en texto plano) |
| **JWT** | Un "pase" digital que demuestra que el usuario ya inició sesión |

---

## Paso 2.2 — Archivo `middlewares/authMiddleware.js`

### Qué hacer
1. Crea `backend/middlewares/authMiddleware.js`.
2. Copia el código del archivo del proyecto.

### Qué hace
Es un **guardián**. Revisa si la petición trae un token JWT válido.  
Lo usaremos en el carrito (Clase 3).

---

## Paso 2.3 — Archivo `controllers/authController.js`

### Qué hacer
1. Crea `backend/controllers/authController.js`.
2. Copia el código del proyecto.

### Qué hace
- Función `register` → crea usuario, encripta contraseña, devuelve token
- Función `login` → verifica credenciales, devuelve token

### Qué es un "controller"
Recibe la petición, habla con la base de datos y devuelve la respuesta.  
Es como el **mesero** del restaurante: toma el pedido y trae la comida.

---

## Paso 2.4 — Archivo `routes/authRoutes.js`

### Qué hacer
1. Crea `backend/routes/authRoutes.js`.
2. Copia el código del proyecto.

### Qué hace
Define las URLs:
- `POST /api/auth/register` → registro
- `POST /api/auth/login` → login

### Qué es una "ruta"
Es la **dirección** que usa la app para pedir algo al servidor.  
Ejemplo: `http://localhost:3000/api/auth/login`

---

## Paso 2.5 — Conectar las rutas en `index.js`

### Qué hacer
Abre `backend/index.js` y verifica que tenga esta línea (copia del proyecto si falta):

```javascript
app.use('/api/auth', authRoutes);
```

Y el import al inicio:

```javascript
const authRoutes = require('./routes/authRoutes');
```

---

### Paso 2.6 — Reiniciar el servidor (terminal)

Cada vez que cambies archivos del backend, debes **reiniciar** el servidor:

1. Ve a la terminal donde corre `npm run dev`.
2. Presiona `Ctrl + C` para detenerlo.
3. Asegúrate de estar en `backend`:

```
cd "C:\Users\johan\Documents\SALLE\2026-2\Computación Móvil\appTienda"
cd backend
```

4. Vuelve a encenderlo:

```
npm run dev
```

5. Debe decir otra vez: `Servidor corriendo en http://localhost:3000`

---

### Paso 2.7 — Cómo probar (con Thunder Client)

**Opción fácil — Thunder Client en Cursor/VS Code:**
1. Instala la extensión "Thunder Client".
2. Crea una petición `POST` a `http://localhost:3000/api/auth/register`
3. En Body → JSON, envía:

```json
{
  "name": "Juan",
  "email": "juan@test.com",
  "password": "123456"
}
```

4. Debe responder con `token` y datos del usuario.

5. Repite con `POST` a `http://localhost:3000/api/auth/login` con email y password.

**También puedes verificar en Workbench:**
```sql
SELECT * FROM users;
```
Debe aparecer el usuario que registraste.

**¡Clase 2 terminada!** Ya tienes registro y login en el servidor.

---

# CLASE 3 — Categorías, productos y carrito (API REST)

**Objetivo de hoy:** Completar todas las rutas del backend.

---

## Paso 3.1 — Categorías

### Archivos a crear (en este orden)

| Archivo | Copiar de |
|---------|-----------|
| `backend/controllers/categoryController.js` | El del proyecto |
| `backend/routes/categoryRoutes.js` | El del proyecto |

### Qué hace
- `GET /api/categories` → devuelve las 4 categorías de la BD

### Probar en el navegador (terminal del servidor encendido)

Con `npm run dev` activo, abre Chrome y visita:

```
http://localhost:3000/api/categories
```

Debes ver un JSON con Electrónica, Ropa, Hogar, Deportes.

---

## Paso 3.2 — Productos

### Archivos a crear

| Archivo | Copiar de |
|---------|-----------|
| `backend/controllers/productController.js` | El del proyecto |
| `backend/routes/productRoutes.js` | El del proyecto |

### Rutas que creas

| Método | URL | Qué hace |
|--------|-----|----------|
| GET | `/api/products` | Todos los productos |
| GET | `/api/products/:id` | Un producto por ID |
| GET | `/api/products/category/:categoryId` | Productos de una categoría |

### Probar
```
http://localhost:3000/api/products
http://localhost:3000/api/products/1
http://localhost:3000/api/products/category/1
```

---

## Paso 3.3 — Carrito (persistencia en BD)

### Archivos a crear

| Archivo | Copiar de |
|---------|-----------|
| `backend/controllers/cartController.js` | El del proyecto |
| `backend/routes/cartRoutes.js` | El del proyecto |

### Rutas (todas requieren JWT — header `Authorization: Bearer TOKEN`)

| Método | URL | Qué hace |
|--------|-----|----------|
| GET | `/api/cart` | Ver mi carrito |
| POST | `/api/cart` | Agregar producto |
| PUT | `/api/cart/:id` | Cambiar cantidad |
| DELETE | `/api/cart/:id` | Eliminar del carrito |

### Probar con Thunder Client
1. Primero haz login y copia el `token` de la respuesta.
2. En cada petición del carrito, agrega el header:
   - Nombre: `Authorization`
   - Valor: `Bearer TU_TOKEN_AQUI`
3. Prueba `POST /api/cart` con body:
```json
{
  "product_id": 1,
  "quantity": 2
}
```
4. En Workbench verifica:
```sql
SELECT * FROM cart_items;
```

---

## Paso 3.4 — Verificar `index.js` completo

Abre `backend/index.js` del proyecto y asegúrate de que tu archivo tenga **todas** las rutas:

```javascript
app.use('/api/auth', authRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/products', productRoutes);
app.use('/api/cart', cartRoutes);
```

---

### Paso 3.5 — Reiniciar el servidor (terminal)

**Obligatorio** después de cambiar `index.js`:

1. En la terminal del servidor, presiona `Ctrl + C`.
2. Escribe:

```
cd "C:\Users\johan\Documents\SALLE\2026-2\Computación Móvil\appTienda"
cd backend
npm run dev
```

3. Comprueba en Chrome:

```
http://localhost:3000/api/products
```

Si ves la lista de productos en JSON, el backend está completo.

**¡Clase 3 terminada!** El backend está completo. Ahora viene Flutter.

---

# CLASE 4 — App Flutter: login y registro

**Objetivo de hoy:** Pantallas de login y registro que hablen con el servidor.

---

## Paso 4.1 — Crear el proyecto Flutter

### Qué hacer (terminal)

Si empiezas **desde cero** (carpeta vacía sin proyecto Flutter):

1. Abre una **nueva terminal**.
2. Ve a la carpeta donde quieres el proyecto:

```
cd "C:\Users\johan\Documents\SALLE\2026-2\Computación Móvil\appTienda"
```

3. Crea el proyecto Flutter:

```
flutter create --org com.apptienda --project-name app_tienda .
```

Espera a que termine. Puede tardar varios minutos.

Si **ya tienes** la carpeta del proyecto con archivos Flutter, **salta este paso**.

---

## Paso 4.2 — Configurar `pubspec.yaml`

### Qué hacer
1. Abre `pubspec.yaml`.
2. En `dependencies`, agrega (o copia del proyecto):

```yaml
http: ^1.2.2
provider: ^6.1.2
shared_preferences: ^2.3.2
```

---

### Paso A — Instalar dependencias de Flutter (terminal)

1. Abre la terminal (**Terminal → Nueva terminal**).
2. Ve a la **raíz** del proyecto (NO entres a `backend`):

```
cd "C:\Users\johan\Documents\SALLE\2026-2\Computación Móvil\appTienda"
```

3. Descarga las librerías de Flutter:

```
flutter pub get
```

4. Espera a que diga `Got dependencies`.

> **Ojo:** `flutter pub get` se ejecuta en la carpeta `appTienda`, no en `backend`.

### Qué hace cada librería

| Librería | Para qué sirve |
|----------|----------------|
| `http` | Enviar peticiones al servidor |
| `provider` | Manejar el estado (¿está logueado? ¿qué productos hay?) |
| `shared_preferences` | Guardar el token en el navegador |

---

## Paso 4.3 — Crear carpetas en `lib/`

Dentro de `lib/`, crea estas carpetas vacías:

```
lib/
├── core/
├── models/
├── services/
├── providers/
├── screens/
└── widgets/
```

---

## Paso 4.4 — Archivos de configuración (`core/`)

### Archivos a crear (en este orden)

| Archivo | Copiar de |
|---------|-----------|
| `lib/core/app_url_stub.dart` | El del proyecto |
| `lib/core/app_url_io.dart` | El del proyecto |
| `lib/core/app_url_web.dart` | El del proyecto |
| `lib/core/app_url.dart` | El del proyecto |
| `lib/core/constants.dart` | El del proyecto |

### Qué hace
Define la **dirección del servidor**. En Chrome usa `http://localhost:3000/api`.

> **No borres estos archivos.** Sin ellos la app falla en Chrome.

---

## Paso 4.5 — Modelos (`models/`)

Los **modelos** describen la forma de los datos (como una plantilla).

| Archivo | Representa |
|---------|------------|
| `lib/models/user.dart` | Usuario (id, nombre, email) |
| `lib/models/category.dart` | Categoría |
| `lib/models/product.dart` | Producto |
| `lib/models/cart_item.dart` | Ítem del carrito |

### Qué hacer
Crea cada archivo y copia el código del proyecto.

### Qué aprendiste
Cuando el servidor envía JSON, el modelo lo convierte en un objeto que Flutter entiende (`fromJson`).

---

## Paso 4.6 — Servicios (`services/`)

| Archivo | Copiar de | Qué hace |
|---------|-----------|----------|
| `lib/services/storage_service.dart` | El del proyecto | Guarda/lee el token JWT |
| `lib/services/api_service.dart` | El del proyecto | Todas las llamadas al servidor |

### Orden importante
1. Primero `storage_service.dart` (más simple)
2. Luego `api_service.dart` (usa storage para enviar el token)

---

## Paso 4.7 — Provider de autenticación

| Archivo | Copiar de |
|---------|-----------|
| `lib/providers/auth_provider.dart` | El del proyecto |

### Qué hace
- Maneja si el usuario está logueado o no
- Llama a `api_service` para register y login
- Notifica a las pantallas cuando cambia el estado

---

## Paso 4.8 — Pantallas de login y registro

| Archivo | Copiar de |
|---------|-----------|
| `lib/screens/login_screen.dart` | El del proyecto |
| `lib/screens/register_screen.dart` | El del proyecto |

### Qué hace cada pantalla

**`login_screen.dart`**
- Campos: email y contraseña
- Botón "Iniciar sesión"
- Enlace a registro

**`register_screen.dart`**
- Campos: nombre, email y contraseña
- Botón "Registrarse"

### Cómo crear un archivo de pantalla en Cursor
1. Clic derecho en la carpeta `screens` → **New File**
2. Nombre: `login_screen.dart`
3. Abre el archivo del proyecto → copia todo → pega en el tuyo

---

## Paso 4.9 — Archivo `main.dart` (versión Clase 4)

### Qué hacer
Abre `lib/main.dart` del proyecto y copia el código.

Por ahora la app debe:
- Configurar `Provider` con `AuthProvider`
- Mostrar `LoginScreen` o `HomeScreen` según si hay sesión
- Tener `SplashScreen` que carga el token guardado

### Cómo probar (dos terminales — paso a paso)

#### Terminal 1 — Backend (servidor)

1. **Terminal → Nueva terminal**.
2. Escribe uno por uno:

```
cd "C:\Users\johan\Documents\SALLE\2026-2\Computación Móvil\appTienda"
cd backend
npm run dev
```

3. Debe decir: `Servidor corriendo en http://localhost:3000`
4. **Deja esta terminal abierta.**

#### Terminal 2 — App Flutter (Chrome)

1. **Terminal → Nueva terminal** (segunda pestaña).
2. Escribe uno por uno:

```
cd "C:\Users\johan\Documents\SALLE\2026-2\Computación Móvil\appTienda"
flutter pub get
flutter run -d chrome
```

3. Espera a que compile (la primera vez tarda varios minutos).
4. Se abrirá Chrome con la pantalla de login.

#### Probar en la app

1. Toca **"¿No tienes cuenta? Regístrate"**.
2. Crea un usuario nuevo.
3. Cierra Chrome y en Terminal 2 presiona `q` + Enter.
4. Vuelve a ejecutar `flutter run -d chrome` → debe recordar la sesión.

> **Recuerda:** Usa `flutter run -d chrome`, **no** `flutter run -d windows`.  
> Ver `ejecutar.md` si tienes dudas.

**¡Clase 4 terminada!** Ya tienes login y registro en Flutter.

---

# CLASE 5 — Home, productos, carrito y cerrar sesión

**Objetivo de hoy:** Completar la tienda.

---

## Paso 5.1 — Providers de productos y carrito

| Archivo | Copiar de | Qué hace |
|---------|-----------|----------|
| `lib/providers/product_provider.dart` | El del proyecto | Carga categorías y productos |
| `lib/providers/cart_provider.dart` | El del proyecto | Maneja el carrito |

### Qué hacer
1. Crea los dos archivos.
2. Copia el código del proyecto.
3. En `main.dart`, agrega los providers (copia del `main.dart` del proyecto):

```dart
ChangeNotifierProvider(create: (_) => ProductProvider()),
ChangeNotifierProvider(create: (_) => CartProvider()),
```

---

## Paso 5.2 — Widgets reutilizables

Los **widgets** son piezas de interfaz que se usan varias veces.

| Archivo | Copiar de | Qué muestra |
|---------|-----------|-------------|
| `lib/widgets/category_chip.dart` | El del proyecto | Botón de categoría |
| `lib/widgets/product_card.dart` | El del proyecto | Tarjeta de un producto |

### Orden
Crea primero `category_chip.dart`, luego `product_card.dart`.

---

## Paso 5.3 — Pantalla principal (`home_screen.dart`)

| Archivo | Copiar de |
|---------|-----------|
| `lib/screens/home_screen.dart` | El del proyecto |

### Qué hace
- Muestra categorías arriba (filtros)
- Muestra productos en cuadrícula
- Icono del carrito con contador
- Botón de cerrar sesión
- Al tocar un producto → va al detalle

---

## Paso 5.4 — Detalle del producto

| Archivo | Copiar de |
|---------|-----------|
| `lib/screens/product_detail_screen.dart` | El del proyecto |

### Qué hace
- Muestra imagen, nombre, precio y descripción
- Botón "Agregar al carrito"

---

## Paso 5.5 — Pantalla del carrito

| Archivo | Copiar de |
|---------|-----------|
| `lib/screens/cart_screen.dart` | El del proyecto |

### Qué hace
- Lista los productos del carrito
- Botones + y - para cantidad
- Botón eliminar
- Muestra el total

---

## Paso 5.6 — Permiso de internet (Android, opcional)

Si más adelante usas emulador Android, abre:

`android/app/src/main/AndroidManifest.xml`

Y verifica que tenga esta línea **antes** de `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

En el proyecto ya está. Solo cópialo si creas el proyecto desde cero.

---

## Paso 5.7 — Probar la app completa (terminal + navegador)

### Encender todo (dos terminales)

**Terminal 1 — Backend:**

```
cd "C:\Users\johan\Documents\SALLE\2026-2\Computación Móvil\appTienda"
cd backend
npm run dev
```

**Terminal 2 — Flutter en Chrome:**

```
cd "C:\Users\johan\Documents\SALLE\2026-2\Computación Móvil\appTienda"
flutter pub get
flutter run -d chrome
```

> Si ya tenías la app abierta y cambiaste código, presiona **`R`** (mayúscula) en Terminal 2 para reiniciar, o `q` + Enter y vuelve a ejecutar `flutter run -d chrome`.

---

### Recorrido de prueba en Chrome

1. **Registrarse** con un usuario nuevo
2. Ver la **lista de productos**
3. **Filtrar** por categoría (toca "Electrónica", "Ropa", etc.)
4. Entrar al **detalle** de un producto
5. **Agregar al carrito**
6. Abrir el **carrito** y cambiar cantidades
7. **Cerrar sesión**
8. Volver a **iniciar sesión** → el carrito debe seguir (está en la BD)

### Verificar en Workbench

```sql
SELECT * FROM cart_items;
```

Debes ver los productos que agregaste.

**¡Clase 5 terminada!** App completa funcionando.

---

# Resumen: reglas de oro

1. **Siempre en orden:** Base de datos → Backend → Flutter
2. **Dentro del backend:** config → controllers → routes → index.js
3. **Dentro de Flutter:** core → models → services → providers → widgets → screens → main.dart
4. **Copia del proyecto:** no inventes código; usa los archivos de referencia
5. **Prueba cada paso:** no avances si lo anterior no funciona
6. **Terminal backend:** siempre `cd backend` antes de `npm install` o `npm run dev`
7. **Terminal Flutter:** siempre en la raíz `appTienda` para `flutter pub get` y `flutter run -d chrome`
8. **Dos terminales abiertas:** una con `npm run dev`, otra con `flutter run -d chrome`
9. **Reinicia el servidor** (`Ctrl + C` → `npm run dev`) cada vez que cambies archivos del backend
10. **Errores comunes:** revisa `ejecutar.md` sección "Problemas frecuentes"

### Comandos de terminal que repetirás siempre

| Momento | Carpeta | Comandos (en orden) |
|---------|---------|---------------------|
| Instalar backend (Clase 1) | `backend` | `cd backend` → `npm install` → `npm install express` → `npm install mysql2` → `npm install cors` → `npm install dotenv` → `npm install bcryptjs` → `npm install jsonwebtoken` |
| Encender servidor | `backend` | `cd backend` → `npm run dev` |
| Instalar Flutter (Clase 4) | `appTienda` | `flutter pub get` |
| Abrir app en Chrome | `appTienda` | `flutter run -d chrome` |

---

# Glosario para principiantes

| Palabra | Significado |
|---------|-------------|
| **API** | Forma en que la app pide datos al servidor |
| **Backend** | Servidor; procesa peticiones y habla con la BD |
| **BD / MySQL** | Base de datos donde se guarda todo |
| **Controller** | Lógica de negocio (qué hacer con cada petición) |
| **Endpoint / Ruta** | URL específica del servidor (ej: `/api/products`) |
| **Flutter** | Framework para crear la interfaz |
| **Frontend** | Lo que ve el usuario (la app) |
| **JSON** | Formato de datos que usan app y servidor |
| **JWT** | Token que prueba que iniciaste sesión |
| **Model** | Plantilla de un dato (Producto, Usuario…) |
| **Provider** | Maneja el estado de la app |
| **Screen** | Una pantalla completa |
| **Service** | Código que se comunica con el servidor |
| **Widget** | Pieza visual de la interfaz |

---

# Checklist final

Marca cada ítem cuando lo tengas funcionando:

- [ ] Base de datos `ecommerceflutter` creada en Workbench
- [ ] Servidor responde en `http://localhost:3000`
- [ ] Registro y login funcionan (Thunder Client o la app)
- [ ] `/api/categories` y `/api/products` devuelven datos
- [ ] Carrito guarda en `cart_items` (con token JWT)
- [ ] App abre en Chrome con `flutter run -d chrome`
- [ ] Puedo registrarme e iniciar sesión en la app
- [ ] Veo productos y filtro por categoría
- [ ] Agrego al carrito y veo el total
- [ ] Cierro sesión correctamente

---

**¡Felicitaciones!** Si completaste todo el checklist, construiste una app de e-commerce real con Flutter, Node.js y MySQL.

Para ejecutarla cada día, usa `ejecutar.md`.  
Para entender qué hace cada archivo, vuelve a esta guía.
