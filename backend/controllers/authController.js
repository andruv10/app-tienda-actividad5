// =============================================================================
// ARCHIVO: controllers/authController.js
// =============================================================================
//
// ANALOGÍA: Es el "mesero" del área de autenticación.
// Recibe el pedido (registro o login), va a la cocina (MySQL) y trae la respuesta.
//
// ¿Qué hace?
// - register: crea un usuario nuevo, encripta la contraseña, devuelve token JWT
// - login: verifica email/contraseña, devuelve token JWT si son correctos
//
// =============================================================================

const bcrypt = require('bcryptjs');   // Encripta contraseñas (nunca guardar en texto plano)
const jwt = require('jsonwebtoken');  // Crea el token JWT
const pool = require('../config/db'); // Conexión a MySQL

// ─── REGISTRO DE USUARIO ───────────────────────────────────────────────────────
async function register(req, res) {
  try {
    // req.body = datos que envía la app (name, email, password)
    const { name, email, password } = req.body;

    // Paso 1: Validar que llegaron todos los campos
    if (!name || !email || !password) {
      return res.status(400).json({ message: 'Nombre, email y contraseña son obligatorios' });
    }

    if (password.length < 6) {
      return res.status(400).json({ message: 'La contraseña debe tener al menos 6 caracteres' });
    }

    // Paso 2: Verificar que el email no esté ya registrado
    const [existing] = await pool.query('SELECT id FROM users WHERE email = ?', [email]);

    if (existing.length > 0) {
      return res.status(400).json({ message: 'El email ya está registrado' });
    }

    // Paso 3: Encriptar la contraseña (el 10 es el "nivel" de seguridad)
    const hashedPassword = await bcrypt.hash(password, 10);

    // Paso 4: Guardar el usuario en la tabla users
    const [result] = await pool.query(
      'INSERT INTO users (name, email, password) VALUES (?, ?, ?)',
      [name, email, hashedPassword]
    );

    // Paso 5: Crear token JWT (válido por 7 días)
    const token = jwt.sign(
      { id: result.insertId, email },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    // Paso 6: Responder a la app con éxito (código 201 = creado)
    res.status(201).json({
      message: 'Usuario registrado correctamente',
      token,
      user: { id: result.insertId, name, email },
    });
  } catch (error) {
    console.error('Error en register:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
}

// ─── INICIO DE SESIÓN ────────────────────────────────────────────────────────
async function login(req, res) {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ message: 'Email y contraseña son obligatorios' });
    }

    // Paso 1: Buscar usuario por email en la BD
    const [users] = await pool.query('SELECT * FROM users WHERE email = ?', [email]);

    if (users.length === 0) {
      return res.status(401).json({ message: 'Credenciales incorrectas' });
    }

    const user = users[0];

    // Paso 2: Comparar contraseña ingresada con la encriptada en BD
    const isValid = await bcrypt.compare(password, user.password);

    if (!isValid) {
      return res.status(401).json({ message: 'Credenciales incorrectas' });
    }

    // Paso 3: Crear token JWT
    const token = jwt.sign(
      { id: user.id, email: user.email },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    // Paso 4: Responder (sin enviar la contraseña al cliente)
    res.json({
      message: 'Inicio de sesión exitoso',
      token,
      user: { id: user.id, name: user.name, email: user.email },
    });
  } catch (error) {
    console.error('Error en login:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
}

module.exports = { register, login };

// =============================================================================
// GLOSARIO
// - controller: lógica que procesa una petición
// - req.body: datos JSON que envía la app en el cuerpo de la petición
// - bcrypt: convierte la contraseña en texto ilegible (hash)
// - JWT: token que identifica al usuario logueado
// - async/await: forma de esperar operaciones (consultas a BD) sin bloquear
// - status 400: error del cliente | 401: no autorizado | 201: creado | 500: error servidor
// =============================================================================
