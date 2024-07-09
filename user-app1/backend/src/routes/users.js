/*

const {Router} = require('express');
const router = Router();

//modelo de bdd
const User=require('../models/User');

//modulo de datos prueba
//const faker = require('faker');
const {faker}=require('@faker-js/faker')

router.get('/api/user',async(req,res) => {
    
    const user =  await User.find();

    res.json(user);

   // res.json('Use List');
});

router.get('/api/user/create',async(req, res)=>{
   //agregar datos de prueba
    for(let i=0; i<5;i++){
      await  User.create({
            firstName: faker.name.firstName(),
            lastName:faker.name.lastName(),
            avatar: faker.image.avatar()

        });

    }

    res.json({message:'5 Users created'})

});

module.exports = router;
*/

const { Router } = require("express");
const router = Router();
const User = require("../models/User");
const { faker } = require("@faker-js/faker");

// Ruta para obtener todos los usuarios
router.get("/api/users", async (req, res) => {
  try {
    const users = await User.find();
    res.json({ users });
  } catch (error) {
    console.error("Error fetching users:", error);
    res.status(500).json({ error: "Error fetching users" });
  }
});

// Ruta para crear usuarios de prueba
router.get("/api/users/create", async (req, res) => {
  try {
    for (let i = 0; i < 5; i++) {
      await User.create({
        firstName: faker.person.firstName(),
        lastName: faker.person.lastName(),
        avatar: faker.image.avatar(),
      });
    }
    res.json({ message: "5 Users created" });
  } catch (error) {
    console.error("Error creating users:", error);
    res.status(500).json({ error: "Error creating users" });
  }
});

// Ruta para actualizar un usuario por ID (PUT)
router.put("/api/users/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { firstName, lastName, avatar } = req.body;
    const user = await User.findByIdAndUpdate(
      id,
      { firstName, lastName, avatar },
      { new: true }
    );
    console.log(user);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }
    res.json(user);
  } catch (error) {
    console.error("Error updating user:", error);
    res.status(500).json({ error: "Error updating user" });
  }
});

// Ruta para eliminar un usuario por ID (DELETE)
router.delete("/api/users/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const user = await User.findByIdAndDelete(id);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }
    res.json({ message: "User deleted successfully" });
  } catch (error) {
    console.error("Error deleting user:", error);
    res.status(500).json({ error: "Error deleting user" });
  }
});

module.exports = router;
