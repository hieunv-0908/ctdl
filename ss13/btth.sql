INSERT INTO posts (user_id, content, created_at)
VALUES (1, '', NOW());

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    total_posts INT DEFAULT 0
);

CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    created_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE post_audits (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    old_content TEXT,
    new_content TEXT,
    changed_at DATETIME
);

INSERT INTO users (username)
VALUES ('nguyenvana');

INSERT INTO posts (user_id, content, created_at)
VALUES (1, 'Bài viết đầu tiên', NOW());

INSERT INTO posts (user_id, content, created_at)
VALUES (1, '', NOW());

