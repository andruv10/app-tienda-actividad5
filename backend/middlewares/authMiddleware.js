// =============================================================================
// ARCHIVO: middlewares/authMiddleware.js
// =============================================================================
//
// ANALOGÍA: Es el guardia de seguridad en la entrada de un edificio.
// Antes de dejarte pasar al carrito, revisa tu "pase" (token JWT).
// Si no tienes pase válido, no entras.
//
// ¿Qué hace?
// - Lee el token que envía la app en el header Authorization
// - Verifica que el token sea válido y no haya expirado
// - Si es válido, guarda los datos del usuario en req.user y deja continuar
// - Si no es válido, responde con error 401 (no autorizado)
//
// =============================================================================

const jwt = require('jsonwebtoken');

function authMiddleware(req, res, next) {
  // req = petición que llega | res = respuesta | next = "continúa al siguiente paso"

  // El token viene en el header: "Authorization: Bearer eyJhbGci..."
  const authHeader = req.headers.authorization;

  // Si no hay header o no empieza con "Bearer ", rechazamos
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'Token no proporcionado' });
  }

  // Separamos "Bearer" del token real (la parte después del espacio)
  const token = authHeader.split(' ')[1];

  try {
    // jwt.verify comprueba que el token sea válido usando JWT_SECRET del .env
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // Guardamos el usuario decodificado para usarlo en el controller (ej: req.user.id)
    req.user = decoded;

    // next() le dice a Express: "todo bien, sigue con la ruta"
    next();
  } catch (error) {
    return res.status(401).json({ message: 'Token inválido o expirado' });
  }
}

module.exports = authMiddleware;

// =============================================================================
// GLOSARIO
// - middleware: función que se ejecuta ANTES del controller
// - JWT: JSON Web Token, el "pase" digital del usuario logueado
// - header: datos extra que viajan con la petición HTTP
// - 401: código HTTP que significa "no autorizado"
// - next(): función para pasar al siguiente paso en Express
// =============================================================================
