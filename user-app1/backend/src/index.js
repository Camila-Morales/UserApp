//const { connect } = require('mongoose');
const app = require('./app');

//Conectar a la bd
const{connect} = require('./database')
async function main (){

    //conectar bd
    await connect();
    //express
    app.listen(4000)
    console.log('Server on port 4000: Connected');
}

main();