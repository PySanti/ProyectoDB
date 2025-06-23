const db = require('../db_connection/index.js');

const loginController = async (req, res) => {
    const { email, password } = req.body;
    if (!email || !password) {
        return res.status(400).json({ error: 'Email and password are required' });
    }

    try {
        const query = 'SELECT * FROM verificar_credenciales($1, $2)';
        const { rows } = await db.query(query, [email, password]);

        if (rows.length > 0) {
            // Usuario autenticado
            res.status(200).json({ message: 'Login successful', user: rows[0] });
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
