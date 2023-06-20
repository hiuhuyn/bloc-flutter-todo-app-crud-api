const db = require('../config/connect_db');

class Post{
    constructor(id, title, image){
        this.id = id ?? 0;
        this.title = title ?? "";
        this.image = image ?? "";
    }
}

Post.selectPostById = function(id, result){
    db.query("SELECT * FROM Post WHERE id =?", id, function (err, post) {
        if (err) {
            log.error("Error getting post");
            result(null);
        } else if(post[0] == undefined){
            result(null);
        } else {
            result(post[0]);
        }
    });
}

Post.getAll = function(result){
    db.query("SELECT * FROM Post", function (err, post) {
        if (err) {
            log.error("Error getting all");
            result(null);
        } else {
            result(post);
        }
    });
}
Post.create = function(require, result){
    var data = {
        id: require.body.id,
        title: require.body.title,
        image: 'http://localhost:3000/images/' + require.file.filename
    };
    db.query("INSERT INTO Post SET?", data, function (err, post) {
            if (err) {
                log.error("Error creating post");
                result(null);
            } else {
                result(post);
            }
        });
}

Post.deletePost = function(id, result){
    Post.selectPostById(id, function(response){
        if(response != null) {
            db.query("DELETE FROM Post WHERE id =?", id, function (err, post) {
                if (err) {
                    log.error("Error deleting post");
                    result(null);
                } else {
                    result(response);
                }
            });
        }
    })
    
}

Post.updatePost = function(require, result ){
    var post = {
        id: require.body.id,
        title: require.body.title,
        image: 'http://localhost:3000/images/' + require.file.filename
    };
    db.query("UPDATE Post SET title =?, image =? WHERE id =?", [post.title, post.image, post.id], function (err, post) {
        if (err) {
            log.error("Error updating post");
            result(null);
        } else {
            result(post);
        }
    });
}


module.exports = Post;

