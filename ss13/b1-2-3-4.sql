CREATE DATABASE trigger_social;
USE trigger_social;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATE,
    follower_count INT DEFAULT 0,
    post_count INT DEFAULT 0
);

CREATE TABLE posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    content TEXT,
    created_at DATETIME,
    like_count INT DEFAULT 0,
    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

INSERT INTO users (username, email, created_at) VALUES
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

DELIMITER //

CREATE TRIGGER tg_increase_post_count
AFTER INSERT ON posts
FOR EACH ROW
BEGIN
    UPDATE users
    SET post_count = post_count + 1
    WHERE user_id = NEW.user_id;
END;
//

DELIMITER ;

DELIMITER //

CREATE TRIGGER tg_decrease_post_count
AFTER DELETE ON posts
FOR EACH ROW
BEGIN
    UPDATE users
    SET post_count = post_count - 1
    WHERE user_id = OLD.user_id;
END;
//

DELIMITER ;
INSERT INTO posts (user_id, content, created_at) VALUES
(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
(1, 'Second post by Alice', '2025-01-10 12:00:00'),
(2, 'Bob first post', '2025-01-11 09:00:00'),
(3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');

SELECT * FROM users;

DELETE FROM posts WHERE post_id = 2;

-- b2
-- 1. Tạo bảng likes
CREATE TABLE likes (
    like_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    post_id INT,
    liked_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,
    FOREIGN KEY (post_id)
        REFERENCES posts(post_id)
        ON DELETE CASCADE
);

-- 2. Thêm dữ liệu mẫu vào likes
INSERT INTO likes (user_id, post_id, liked_at) VALUES
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

-- 3. Trigger cập nhật like_count trong bảng posts

DELIMITER //

CREATE TRIGGER tg_increase_like_count
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END;
//

CREATE TRIGGER tg_decrease_like_count
AFTER DELETE ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;
END;
//

DELIMITER ;

-- 4. Tạo View user_statistics
CREATE VIEW user_statistics AS
SELECT 
    u.user_id,
    u.username,
    u.post_count,
    IFNULL(SUM(p.like_count), 0) AS total_likes
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username, u.post_count;

-- 5. Thêm lượt thích mới và kiểm chứng
INSERT INTO likes (user_id, post_id, liked_at)
VALUES (2, 4, NOW());

SELECT * FROM posts WHERE post_id = 4;
SELECT * FROM user_statistics;

-- 6. Xóa lượt thích và kiểm chứng lại View
DELETE FROM likes
WHERE user_id = 2 AND post_id = 4;

SELECT * FROM posts WHERE post_id = 4;
SELECT * FROM user_statistics;

-- b3
DELIMITER //

CREATE TRIGGER tg_check_self_like_before_insert
BEFORE INSERT ON likes
FOR EACH ROW
BEGIN
    DECLARE post_owner INT;

    SELECT user_id INTO post_owner
    FROM posts
    WHERE post_id = NEW.post_id;

    IF NEW.user_id = post_owner THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không được like bài viết của chính mình';
    END IF;
END;
//

CREATE TRIGGER tg_like_after_insert
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END;
//

CREATE TRIGGER tg_like_after_delete
AFTER DELETE ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;
END;
//

CREATE TRIGGER tg_like_after_update
AFTER UPDATE ON likes
FOR EACH ROW
BEGIN
    IF OLD.post_id <> NEW.post_id THEN
        UPDATE posts
        SET like_count = like_count - 1
        WHERE post_id = OLD.post_id;

        UPDATE posts
        SET like_count = like_count + 1
        WHERE post_id = NEW.post_id;
    END IF;
END;
//

DELIMITER ;


INSERT INTO likes (user_id, post_id)
VALUES (1, 1);

INSERT INTO likes (user_id, post_id)
VALUES (2, 1);

SELECT * FROM posts WHERE post_id = 1;

UPDATE likes
SET post_id = 2
WHERE user_id = 2 AND post_id = 1;

SELECT * FROM posts WHERE post_id IN (1, 2);

DELETE FROM likes
WHERE user_id = 2 AND post_id = 2;

SELECT * FROM posts WHERE post_id = 2;

SELECT * FROM posts;
SELECT * FROM user_statistics;

-- b4 
CREATE TABLE post_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    old_content TEXT,
    new_content TEXT,
    changed_at DATETIME,
    changed_by_user_id INT,
    FOREIGN KEY (post_id)
        REFERENCES posts(post_id)
        ON DELETE CASCADE
);

INSERT INTO post_history (post_id, old_content, new_content, changed_at, changed_by_user_id)
VALUES (1, 'Init content', 'Init content', NOW(), 1);

DELIMITER //

CREATE TRIGGER tg_log_post_update
BEFORE UPDATE ON posts
FOR EACH ROW
BEGIN
    IF OLD.content <> NEW.content THEN
        INSERT INTO post_history (
            post_id,
            old_content,
            new_content,
            changed_at,
            changed_by_user_id
        )
        VALUES (
            OLD.post_id,
            OLD.content,
            NEW.content,
            NOW(),
            OLD.user_id
        );
    END IF;
END;
//

CREATE TRIGGER tg_post_after_delete
AFTER DELETE ON posts
FOR EACH ROW
BEGIN
    DELETE FROM post_history
    WHERE post_id = OLD.post_id;
END;
//

DELIMITER ;

UPDATE posts
SET content = 'Nội dung đã được chỉnh sửa lần 1'
WHERE post_id = 1;

UPDATE posts
SET content = 'Nội dung đã được chỉnh sửa lần 2'
WHERE post_id = 1;

SELECT * FROM post_history;

SELECT * FROM posts;
SELECT * FROM likes;
SELECT * FROM user_statistics;
