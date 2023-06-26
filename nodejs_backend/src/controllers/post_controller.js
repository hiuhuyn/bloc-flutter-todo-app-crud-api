var Post = require('../modules/post_module');
const fs = require('fs');

exports.selectById = function(require, result){
    var id = require.params.id;
    Post.selectPostById(id, function(data){
        result.send(data);
    })
}

exports.getAllPosts = function(require, result){
    Post.getAll(function(data){
        result.send(data);
    })
}
exports.addPost = function(require, result){
    Post.create(require, function(response){
            result.send(response);
        });
}

exports.deletePost = function(require, result){
    var id = require.params.id;
    Post.deletePost(id, function(response){
        if(response != null ){
            // xóa file ảnh
            fs.unlink(response.image, (err) => {
                if (err){
                    console.log(err);
                }else console.log('File deleted successfully');
              });
            result.send('Xóa thành công');
        }else{
            result.send('Xóa thất bại');
        }
    });
}
exports.updatePost = function(require, result){
    Post.updatePost(require, function(response){
        if(response != null){
            result.send('Cập nhật thành công');
        }else{
            result.send('Cập nhật thất bại');
        }
    });
}