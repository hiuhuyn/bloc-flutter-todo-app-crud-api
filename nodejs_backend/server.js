var express = require("express");
var app = express();

// cấu hình body-parser
var bodyParser = require("body-parser");
app.use(bodyParser.urlencoded({ extended: false}))
app.use(bodyParser.json());
require('./src/routes/post_router')(app);

app.listen(4000, function () {
    console.log("Server is running on port 4000");
});