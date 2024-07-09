const express = require("express");
const app = express();

const morgan = require("morgan");
const cors = require("cors");

app.use(morgan("dev")); //Recibir peticiones -- morgan
app.use(cors());
app.use(express.json()); // Ensure this line is present
/* Definir la ruta */
app.use(require("./routes/users"));

module.exports = app;
