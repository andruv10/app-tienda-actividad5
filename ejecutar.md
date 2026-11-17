# Cómo ejecutar la App Tienda (paso a paso)

Esta guía está pensada para personas que **nunca han programado**.  
Sigue cada paso en orden. No te saltes ninguno.

---

## ¿Qué vamos a hacer?

La aplicación tiene **3 partes** que deben estar funcionando al mismo tiempo:

1. **Base de datos (MySQL)** — Donde se guardan los usuarios, productos y el carrito.
2. **Backend (servidor)** — El programa que conecta la app con la base de datos.
3. **App (Flutter)** — Lo que ves en la pantalla. En este curso la ejecutaremos en **Google Chrome** (navegador).

Piénsalo así:

```
App en Chrome  →  Servidor (backend)  →  Base de datos (MySQL)
```

---

## Parte 0: Instalar los programas necesarios

Antes de empezar, necesitas tener instalados estos programas en tu computador.  
Si ya los tienes, pasa a la **Parte 1**.

### 0.1 MySQL y MySQL Workbench

**¿Qué es?** MySQL guarda la información. Workbench es la ventana donde creas las tablas.

1. Entra a: https://dev.mysql.com/downloads/installer/
2. Descarga **MySQL Installer for Windows**.
3. Instala con las opciones por defecto.
4. Durante la instalación te pedirá una **contraseña para el usuario `root`**.  
   **¡Escríbela y no la olvides!** La vas a necesitar después.
5. Asegúrate de que también se instale **MySQL Workbench**.

### 0.2 Node.js

**¿Qué es?** Es el programa que ejecuta el servidor (backend).

1. Entra a: https://nodejs.org/
2. Descarga la versión **LTS** (la que dice "Recommended").
3. Instala con "Siguiente" en todas las pantallas.
4. Para comprobar que quedó bien:
   - Presiona las teclas `Windows + R`.
   - Escribe `cmd` y presiona Enter.
   - En la ventana negra escribe: `node --version` y presiona Enter.
   - Debe aparecer un número como `v20.x.x`.

### 0.3 Flutter y Google Chrome

**¿Qué es Flutter?** Es el programa que crea y ejecuta la app.  
**¿Qué es Chrome?** Es el navegador donde verás la app. **En este curso usaremos Chrome** porque es lo más fácil y no requiere instalar programas extra.

1. Entra a: https://docs.flutter.dev/get-started/install/windows
2. Sigue la guía oficial para instalar Flutter en Windows.
3. Asegúrate de tener **Google Chrome** instalado (https://www.google.com/chrome/).
4. Para comprobar que quedó bien, abre `cmd` y escribe:

```
flutter doctor
```

Debe mostrar Flutter en verde. Si aparece una **X roja en Visual Studio**, no te preocupes: **no la necesitamos** porque usaremos Chrome, no Windows de escritorio.

> **¿Por qué no usamos `flutter run -d windows`?**  
> Ese comando abre la app como programa de Windows (.exe) y necesita instalar **Visual Studio** (varios GB de descarga).  
> Si lo intentas sin Visual Studio, verás este error:
>
> ```
> Error: Unable to find suitable Visual Studio toolchain.
> Please run 'flutter doctor' for more details.
> ```
>
> **Solución del curso:** usar Chrome con `flutter run -d chrome`. Así nadie se atasca.

> **Android Studio** es opcional. Solo lo necesitas si más adelante quieres probar en un emulador de celular.

### 0.4 Visual Studio Code o Cursor (opcional pero recomendado)

**¿Qué es?** Es el editor donde está el código del proyecto.  
Si ya tienes Cursor abierto con el proyecto, ¡perfecto!

---

## Parte 1: Crear la base de datos en MySQL Workbench

### Paso 1.1 — Abrir MySQL Workbench

1. Busca **MySQL Workbench** en el menú de Windows y ábrelo.
2. Verás una conexión llamada **Local instance MySQL** (o similar).
3. Haz clic en ella.
4. Te pedirá la contraseña que pusiste al instalar MySQL. Escríbela y entra.

### Paso 1.2 — Abrir el archivo de la base de datos

1. En Cursor (o el editor que uses), abre la carpeta del proyecto `appTienda`.
2. Dentro encontrarás la carpeta `database`.
3. Abre el archivo `schema.sql`.
4. Selecciona **todo** el contenido del archivo:
   - Presiona `Ctrl + A` (seleccionar todo).
   - Presiona `Ctrl + C` (copiar).

### Paso 1.3 — Ejecutar el script en Workbench

1. Vuelve a MySQL Workbench.
2. En el área grande de texto (donde se escriben consultas), haz clic.
3. Pega el contenido con `Ctrl + V`.
4. Haz clic en el icono del **rayo** ⚡ (o presiona `Ctrl + Shift + Enter`).
5. Abajo debe aparecer en verde algo como "Query OK" o "X rows affected".

**¿Qué acaba de pasar?**  
Se creó la base de datos `ecommerceflutter` con las tablas de usuarios, categorías, productos y carrito, además de datos de ejemplo.

### Paso 1.4 — Verificar que funcionó

1. En el panel izquierdo de Workbench, haz clic en el icono de **refrescar** 🔄.
2. Deberías ver `ecommerceflutter` en la lista.
3. Expándela y verás las tablas: `users`, `categories`, `products`, `cart_items`.

---

## Parte 2: Configurar y ejecutar el servidor (backend)

### Paso 2.1 — Abrir la terminal en la carpeta del backend

1. En Cursor, ve al menú **Terminal → Nueva terminal** (o presiona `` Ctrl + ` ``).
2. Escribe este comando y presiona Enter:

```
cd backend
```

> **Nota:** Si la terminal no está en la carpeta del proyecto, primero escribe:
> `cd "C:\Users\johan\Documents\SALLE\2026-2\Computación Móvil\appTienda"`
> y luego `cd backend`.

### Paso 2.2 — Crear el archivo de configuración

El servidor necesita saber la contraseña de MySQL. Para eso existe un archivo llamado `.env`.

1. En la carpeta `backend`, busca el archivo `.env.example`.
2. Cópialo y pégalo en la misma carpeta.
3. Renombra la copia a `.env` (sin la palabra "example").

Si no puedes renombrarlo desde el explorador, en la terminal escribe:

```
copy .env.example .env
```

### Paso 2.3 — Editar la contraseña de MySQL

1. Abre el archivo `.env` con el editor.
2. Busca esta línea:

```
DB_PASSWORD=tu_password
```

3. Cambia `tu_password` por la contraseña real de MySQL que pusiste al instalar.
4. Guarda el archivo (`Ctrl + S`).

Ejemplo (si tu contraseña fuera `mipassword123`):

```
DB_PASSWORD=mipassword123
```

### Paso 2.4 — Instalar dependencias del servidor

En la terminal (dentro de la carpeta `backend`), escribe:

```
npm install
```

Espera a que termine. Puede tardar unos segundos o minutos.

### Paso 2.5 — Iniciar el servidor

En la misma terminal, escribe:

```
npm run dev
```

> **Nota:** También puedes usar `npm start`; en este proyecto ambos hacen lo mismo.  
> Usamos `npm run dev` porque indica que estás en modo **desarrollo** (probando la app en tu computador).

Si todo está bien, verás este mensaje:

```
Servidor corriendo en http://localhost:3000
```

**¡Muy importante!**  
**No cierres esta ventana de la terminal.** El servidor debe seguir abierto mientras uses la app.

### Paso 2.6 — Comprobar que el servidor funciona

1. Abre tu navegador (Chrome, Edge, etc.).
2. Escribe en la barra de direcciones: `http://localhost:3000`
3. Debes ver algo como: `{"message":"API E-commerce funcionando"}`

Si ves eso, el servidor está funcionando correctamente.

---

## Parte 3: Ejecutar la app en Google Chrome (Flutter)

En esta parte abriremos la app en el **navegador Chrome**. Es la forma recomendada para el curso.

### Paso 3.1 — Abrir una segunda terminal

Necesitas **otra terminal** porque la primera sigue con el servidor encendido.

1. En Cursor: **Terminal → Nueva terminal**.
2. Asegúrate de estar en la carpeta principal del proyecto (`appTienda`).

Si no estás ahí, escribe:

```
cd "C:\Users\johan\Documents\SALLE\2026-2\Computación Móvil\appTienda"
```

> **Tip:** Si no sabes en qué carpeta estás, mira la ruta al inicio de la línea en la terminal. Debe terminar en `appTienda`.

### Paso 3.2 — Descargar dependencias de Flutter

Escribe:

```
flutter pub get
```

Espera a que termine. Debe decir algo como "Got dependencies" al final.

### Paso 3.3 — Verificar que Chrome está disponible

Escribe:

```
flutter devices
```

Debes ver una línea que diga **Chrome** en la lista. Ejemplo:

```
Chrome (web) • chrome • web-javascript • Google Chrome
```

Si Chrome aparece, puedes continuar. Si no aparece, instala Google Chrome y vuelve a intentar.

### Paso 3.4 — Ejecutar la app en Chrome

Escribe exactamente:

```
flutter run -d chrome
```

**¿Qué hace este comando?**
- `flutter run` = compila y ejecuta la app.
- `-d chrome` = la abre en Google Chrome (no en Windows ni en celular).

La primera vez puede tardar **varios minutos**. Es normal. No cierres la terminal.

Cuando termine:
1. Se abrirá una ventana de **Chrome** automáticamente.
2. Verás la pantalla de inicio de sesión de **App Tienda**.

### Paso 3.5 — Si la terminal pregunta algo

A veces Flutter pregunta en qué dispositivo ejecutar. Si ves una lista, elige el número de **Chrome** y presiona Enter.

### Paso 3.6 — Detener la app

Cuando termines de probar:
1. Ve a la terminal donde corre Flutter.
2. Presiona `q` y luego Enter para cerrar la app.
3. O simplemente cierra la pestaña de Chrome.

---

### Otras formas de ejecutar (opcional, no obligatorio)

Estas opciones **no son necesarias** para el curso. Solo úsalas si ya tienes todo configurado.

#### Emulador Android (celular virtual)

Requiere Android Studio instalado y un emulador encendido.

```
flutter emulators --launch Pixel_8_Pro
flutter run
```

#### Windows de escritorio (NO recomendado para el curso)

Requiere instalar Visual Studio con "Desarrollo para el escritorio con C++".  
Si no lo tienes, verás el error de Visual Studio toolchain. **Usa Chrome en su lugar.**

```
flutter run -d windows
```

---

## Parte 4: Usar la aplicación

### Crear una cuenta

1. En la pantalla de inicio, toca **"¿No tienes cuenta? Regístrate"**.
2. Escribe tu nombre, email y contraseña (mínimo 6 caracteres).
3. Toca **Registrarse**.

### Iniciar sesión

Si ya tienes cuenta, escribe tu email y contraseña y toca **Iniciar sesión**.

### Explorar la tienda

- Verás productos en una cuadrícula.
- Arriba puedes filtrar por categoría (Electrónica, Ropa, Hogar, Deportes).
- Toca un producto para ver su detalle.
- Toca **Agregar al carrito** para guardarlo.
- El icono del carrito 🛒 arriba a la derecha muestra cuántos productos llevas.
- Toca el icono de salir para **cerrar sesión**.

---

## Resumen: orden de ejecución cada vez que uses la app

Cada vez que quieras usar la aplicación, haz esto **en este orden**:

| Paso | Qué hacer | ¿Cerrar después? |
|------|-----------|------------------|
| 1 | MySQL debe estar instalado y funcionando | No |
| 2 | Terminal 1 → `cd backend` → `npm run dev` | **No cerrar** |
| 3 | Terminal 2 → `flutter run -d chrome` | Cerrar cuando termines (`q` + Enter) |

---

## Problemas frecuentes y soluciones

### "Unsupported operation: Platform._operatingSystem"

**¿Qué significa?** La app intentó usar código de celular/Windows que **no funciona en Chrome**.

**Solución:** Este error ya está corregido en el proyecto. Si lo ves:
1. Detén la app en la terminal (`q` + Enter).
2. Vuelve a ejecutar:

```
flutter run -d chrome
```

3. Si persiste, escribe `r` en la terminal de Flutter para recargar (hot reload) o reinicia el comando.

---

### "Unable to find suitable Visual Studio toolchain"

**¿Qué significa?** Intentaste ejecutar la app como programa de Windows con `flutter run -d windows`, pero no tienes Visual Studio instalado.

**Solución (la del curso):** No uses Windows. Usa Chrome:

```
flutter run -d chrome
```

No necesitas instalar Visual Studio para este curso.

---

### "Error al iniciar sesión" o "Error en la solicitud"

**Causa:** El servidor no está encendido o la base de datos no está creada.

**Solución:**
1. Verifica que MySQL esté corriendo.
2. Verifica que ejecutaste `schema.sql` en Workbench.
3. Verifica que la terminal del servidor dice `Servidor corriendo en http://localhost:3000`.
4. Abre `http://localhost:3000` en Chrome y comprueba que ves el mensaje de la API.
5. Verifica que el backend sigue abierto (Terminal 1 no cerrada).

---

### Chrome no abre o no aparece en `flutter devices`

**Causa:** Google Chrome no está instalado o Flutter no lo detecta.

**Solución:**
1. Instala Chrome desde https://www.google.com/chrome/
2. Cierra y vuelve a abrir la terminal.
3. Escribe `flutter devices` y verifica que Chrome aparece.
4. Vuelve a ejecutar `flutter run -d chrome`.

---

### La compilación tarda mucho o parece congelada

**Causa:** La primera vez Flutter descarga y compila muchas cosas.

**Solución:**
1. Espera al menos 5–10 minutos la primera vez.
2. No cierres la terminal.
3. Si después de mucho tiempo sigue igual, presiona `Ctrl + C` para cancelar.
4. Vuelve a ejecutar `flutter run -d chrome`.

---

### "Access denied for user 'root'" en el servidor

**Causa:** La contraseña en el archivo `.env` es incorrecta.

**Solución:**
1. Abre `backend/.env`.
2. Corrige `DB_PASSWORD` con tu contraseña real de MySQL.
3. Guarda y vuelve a ejecutar `npm run dev`.

---

### La app en Chrome no conecta con el servidor

**Causa:** El backend no está corriendo o la URL no es correcta.

**Solución:**
1. En Chrome abre `http://localhost:3000` — debe mostrar el mensaje de la API.
2. Si no funciona, revisa que Terminal 1 tenga `npm run dev` activo.
3. En Chrome la app usa `http://localhost:3000/api` automáticamente (ya está configurado en el proyecto).

---

### La app no conecta (emulador Android, solo si lo usas)

**Causa:** El emulador no puede usar `localhost` igual que tu PC.

**Solución:**  
Ya está configurado en el proyecto. El emulador Android usa `10.0.2.2` automáticamente.  
Solo asegúrate de que el servidor esté corriendo en tu PC.

### La app no conecta (celular físico, solo si lo usas)

**Causa:** El celular y la PC deben estar en la misma red WiFi, y debes usar la IP de tu PC.

**Solución:**
1. En tu PC, abre `cmd` y escribe `ipconfig`.
2. Busca tu **IPv4** (ejemplo: `192.168.1.50`).
3. Abre el archivo `lib/core/constants.dart`.
4. Cambia la dirección por tu IP, por ejemplo:
   ```
   return 'http://192.168.1.50:3000/api';
   ```
5. Guarda y vuelve a ejecutar `flutter run -d chrome` (o el dispositivo que uses).

---

### "flutter no se reconoce como comando"

**Causa:** Flutter no está instalado o no está en el PATH.

**Solución:** Reinstala Flutter siguiendo la guía oficial y reinicia la computadora.

### "npm no se reconoce como comando"

**Causa:** Node.js no está instalado correctamente.

**Solución:** Reinstala Node.js desde https://nodejs.org/ y reinicia la computadora.

---

## ¿Necesitas ayuda?

Si algo no funciona, revisa en este orden:

1. ¿MySQL Workbench abre y muestra la base de datos `ecommerceflutter`?
2. ¿El archivo `backend/.env` tiene la contraseña correcta de MySQL?
3. ¿La terminal del servidor dice `Servidor corriendo en http://localhost:3000`?
4. ¿`http://localhost:3000` en Chrome muestra el mensaje de la API?
5. ¿Ejecutaste `flutter pub get` antes de `flutter run -d chrome`?
6. ¿Usaste `flutter run -d chrome` y **no** `flutter run -d windows`?

Si los 6 puntos anteriores están bien, la app debería abrirse en Chrome con la pantalla de login.
