const mongoose = require('mongoose');

async function connect(){
	await mongoose.connect('mongodb://localhost:27017/flutter'),
//	{
	//useNewUrlParser:true
	//};
	console.log('Database: Connected');
};

module.exports={connect};