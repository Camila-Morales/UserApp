
/*const {Schema,model} = require('mongoose');

//lo que se va a guardar en bdd
const userSchema = new Schema({
    firstName: String,
    lastName: String,
    image: String,

});

//me devuelve un modelo de base de datos

model.exports = model('User', userSchema); */


const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  firstName: {
    type: String,
    required: true
  },
  lastName: {
    type: String,
    required: true
  },
  avatar: {
    type: String,
    required: true
  }
});

const User = mongoose.model('User', UserSchema);

module.exports = User;
