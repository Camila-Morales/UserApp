const express = require('express');
const app = express();

const morgan = require('morgan');
const cors = require('cors');

app.use(morgan('dev')); //Recibir peticiones -- morgan
app.use(cors());
/* Definir la ruta */
app.use(require('./routes/users'));

module.exports = app;