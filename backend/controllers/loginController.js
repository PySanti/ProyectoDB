const {pool} = require("../db_connection/index.js")

const loginController = async (req, res) => {
  console.log("Llamando a login controller")
  try{
    const {rows} = await pool.query("SELECT * FROM estatus")
    console.log(rows)
  } catch(e){
    console.log(e)
  }
};



module.exports = {
  loginController
};
