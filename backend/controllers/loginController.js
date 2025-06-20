// controllers/userController.js
const loginController = (req, res) => {
  console.log("Llamada desde login controller")
  res.json({ message: "Obtener usuario con ID: " + req.params.id });
};



module.exports = {
  loginController
};
