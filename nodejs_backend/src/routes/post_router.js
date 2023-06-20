
const { log } = require('console');
const multer = require('multer');
const path = require('path');


var storage = multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, 'images/')
    },
    filename: function (req, file, cb) {
      cb(null,Date.now() + '-' + file.originalname )
    }
  })
const upload = multer({ storage: storage });
module.exports = function(router){
    var posController = require('../controllers/post_controller');
    router.get('/get-post', posController.getAllPosts);
    router.post('/add-post', upload.single('image'), posController.addPost);
}