const db = require('../db_connection/index.js');

const loginController = async (req, res) => {
    const { email, password } = req.body;
    console.log('Intento de login:', { email, password });
    if (!email || !password) {
        return res.status(400).json({ error: 'Email and password are required' });
    }

    try {
        const query = 'SELECT * FROM verificar_credenciales($1, $2)';
        console.log('Query:', query, 'Params:', [email, password]);
        const { rows } = await db.query(query, [email, password]);

        if (rows.length > 0) {
            // Usuario autenticado
            let user = rows[0];
            // Determinar el rol
            if (user.id_cliente_natural) user.rol = 'cliente_natural';
            else if (user.id_cliente_juridico) user.rol = 'cliente_juridico';
            else if (user.id_proveedor) user.rol = 'proveedor';
            else if (user.empleado_id) user.rol = 'administrador'; // O 'empleado', según tu lógica
            else user.rol = 'desconocido';

            res.status(200).json({ message: 'Login successful', user });
        } else {
            // Credenciales incorrectas
            res.status(401).json({ error: 'Invalid credentials' });
        }
    } catch (error) {
        console.error('Error during login:', error);
        res.status(500).json({ error: 'Internal server error' });
    }


};

module.exports = {
  loginController
};
