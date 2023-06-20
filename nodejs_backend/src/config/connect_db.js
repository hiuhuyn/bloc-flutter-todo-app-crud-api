var mysql = require('mysql');

var connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'demo_node_1'
});

connection.connect(function(err, connection) {
    if(err) console.log("Kết nối không thành công")
})

module.exports = connection