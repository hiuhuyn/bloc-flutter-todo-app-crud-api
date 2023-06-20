const db = require('../config/connect_db');

class Post{
    constructor(id, title, image){
        this.id = id ?? 0;
        this.title = title ?? "";
        this.image = image ?? "";
    }
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
        image: require.file.path
    };
    console.log(require.file);

    db.query("INSERT INTO Post SET?", data, function (err, post) {
            if (err) {
                log.error("Error creating post");
                result(null);
            } else {
                result(post);
            }
        });
}
module.exports = Post;

