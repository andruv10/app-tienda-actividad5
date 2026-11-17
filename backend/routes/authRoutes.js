// =============================================================================
// ARCHIVO: routes/authRoutes.js
// =============================================================================
//
// ANALOGÍA: Es el "menú de opciones" del área de autenticación.
// Indica qué URLs existen y qué función atiende cada una.
//
// URLs que crea:
// - POST /api/auth/register → función register
// - POST /api/auth/login    → función login
//
// =============================================================================

const express = require('express');
const { register, login } = require('../controllers/authController');

// Router = mini-aplicación que agrupa rutas relacionadas
const router = express.Router();

// POST = enviar datos para crear algo o verificar algo
router.post('/register', register); // Cuando llegue POST a /register, ejecuta register()
router.post('/login', login);       // Cuando llegue POST a /login, ejecuta login()

module.exports = router;

// =============================================================================
// GLOSARIO
// - router: agrupa rutas bajo un mismo prefijo (/api/auth)
// - POST: método HTTP para enviar datos (registro, login)
// - require(): importa código de otro archivo
// =============================================================================
