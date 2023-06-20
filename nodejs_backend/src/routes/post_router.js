
const { log } = require('console');
const multer = require('multer');
const path = require('path');


var storage = multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, './images')
    },
    filename: function (req, file, cb) {
      cb(null, Date.now() + '-' + file.originalname )
    }
  })
const upload = multer({ storage: storage });
module.exports = function(router){
    var posController = require('../controllers/post_controller');
    router.get('/select-by-id/:id', posController.selectById);
    router.get('/select-post-all', posController.getAllPosts);
    router.post('/add-post', upload.single('image'), posController.addPost);
    router.get('/images/:filename', function(req, res) {
      res.sendFile(path.join(__dirname, '../../images', req.params.filename))
    });
    router.delete('/delete-post/:id', posController.deletePost);
    router.put('/update-post', upload.single('image'), posController.updatePost);
}