CREATE DATABASE IF NOT EXISTS social_network_pro;
USE social_network_pro;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    hometown VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (username),
    UNIQUE (email)
);

INSERT INTO Users (username, email, password, hometown)
VALUES
('an', 'an@gmail.com', '123456', 'Hà Nội'),
('binh', 'binh@gmail.com', '123456', 'Hải Phòng'),
('cuong', 'cuong@gmail.com', '123456', 'Đà Nẵng');

SELECT * FROM Users;

CREATE VIEW vw_public_users AS
SELECT user_id, username, created_at
FROM Users;

SELECT * FROM vw_public_users;

CREATE INDEX idx_username ON Users(username);

SELECT * FROM Users WHERE username = 'an';

CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

DELIMITER //

CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    IF EXISTS (SELECT 1 FROM Users WHERE user_id = p_user_id) THEN
        INSERT INTO Posts(user_id, content)
        VALUES (p_user_id, p_content);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User không tồn tại';
    END IF;
END //

DELIMITER ;

CALL sp_create_post(1, 'Bài viết đầu tiên của tôi');
CALL sp_create_post(2, 'Xin chào mọi người');
CALL sp_create_post(3, 'Hôm nay học SQL');

CREATE VIEW vw_recent_posts AS
SELECT p.post_id, u.username, p.content, p.created_at
FROM Posts p
JOIN Users u ON p.user_id = u.user_id
WHERE p.created_at >= NOW() - INTERVAL 7 DAY;

SELECT * FROM vw_recent_posts ORDER BY created_at DESC;

CREATE INDEX idx_posts_user ON Posts(user_id);
CREATE INDEX idx_posts_user_time ON Posts(user_id, created_at);

SELECT *
FROM Posts
WHERE user_id = 1
ORDER BY created_at DESC;

DELIMITER //

CREATE PROCEDURE sp_count_posts(
    IN p_user_id INT,
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM Posts
    WHERE user_id = p_user_id;
END //

DELIMITER ;

CALL sp_count_posts(1, @total_posts);
SELECT @total_posts AS total_posts;

CREATE VIEW vw_active_users AS
SELECT *
FROM Users
WHERE hometown IS NOT NULL
WITH CHECK OPTION;

DELIMITER //

CREATE PROCEDURE sp_add_friend(
    IN p_user_id INT,
    IN p_friend_id INT
)
BEGIN
    IF p_user_id = p_friend_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể kết bạn với chính mình';
    ELSE
        SELECT 'Gửi lời mời kết bạn thành công' AS message;
    END IF;
END //

DELIMITER ;

CALL sp_add_friend(1, 2);

DELIMITER //

CREATE PROCEDURE sp_suggest_friends(
    IN p_user_id INT,
    INOUT p_limit INT
)
BEGIN
    DECLARE i INT DEFAULT 0;

    WHILE i < p_limit DO
        SELECT user_id, username
        FROM Users
        WHERE user_id <> p_user_id
        LIMIT 1 OFFSET i;
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

SET @limit = 2;
CALL sp_suggest_friends(1, @limit);
