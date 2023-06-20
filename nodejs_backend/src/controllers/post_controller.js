var Post = require('../modules/post_module');


exports.getAllPosts = function(require, result){
    Post.getAll(function(data){
        result.send(data);
    })
}
exports.addPost = function(require, result){
    Post.create(require, function(response){
            result.send({result: response});
        });
}