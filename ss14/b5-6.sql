-- c5
alter table users 
add total_posts int default 0;

insert into posts (user_id,content,privacy,created_at) value ();

delimiter //
drop procedure update_total_posts;
create procedure update_total_posts (in_user_id int,in_content text,in_privacy enum('private','public','friend'),in_created_at date)
begin
   	declare ck_user int;
	declare exit handler for sqlexception
    begin
		rollback;
    end;
    
	if in_content is null or trim(in_content) = '' then
		start transaction;
		rollback;
        signal sqlstate '45000'
        set message_text = 'Lỗi nhập thông tin không hợp lệ !';
	else 
		select count(*) into ck_user from users where user_id = in_user_id;
        if ck_user = 0 then
			start transaction;
			rollback;
			signal sqlstate '45000'
			set message_text = 'Người dùng không tồn tại !';
		else
			start transaction;
			insert into posts (user_id,content,privacy,created_at) value (in_user_id,in_content,in_privacy,in_created_at);
			update users set total_posts = total_posts + 1 where user_id = in_user_id;
            commit;
        end if;
    end if;
end //
delimiter ;

call update_total_posts(1,'Thu transaction','public',current_date());
call update_total_posts(1,null,'public',current_date());

-- c6
alter table posts
add like_count int default 0;

create table likes(
	like_id int auto_increment primary key,
    post_id int not null,
    user_id int not null,
    unique key unique_like (post_id,user_id),
    foreign key (post_id) references posts(post_id),
	foreign key (user_id) references users(user_id)
);

delimiter //

create procedure insert_like(in_user_id int, in_post_id int)
begin
    declare exit handler for sqlexception
    begin
        rollback;
        signal sqlstate '45000'
        set message_text = 'Like thất bại (có thể đã like rồi)';
    end;

    if (select count(*) from users where user_id = in_user_id) = 0
       or (select count(*) from posts where post_id = in_post_id) = 0 then
        signal sqlstate '45000'
        set message_text = 'Không tìm thấy người dùng hoặc bài viết';
    end if;

    start transaction;

    insert into likes (post_id, user_id)
    values (in_post_id, in_user_id);

    update posts
    set like_count = like_count + 1
    where post_id = in_post_id;

    commit;
end //

delimiter ;


call insert_like(1,1);
call insert_like(2,1);
call insert_like(10,10);

ALTER TABLE users
ADD following_count INT DEFAULT 0,
ADD followers_count INT DEFAULT 0;

CREATE TABLE followers (
    follower_id INT NOT NULL,
    followed_id INT NOT NULL,
    PRIMARY KEY (follower_id, followed_id),
    FOREIGN KEY (follower_id) REFERENCES users(user_id),
    FOREIGN KEY (followed_id) REFERENCES users(user_id)
);

CREATE TABLE follow_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    follower_id INT,
    followed_id INT,
    error_message VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE PROCEDURE sp_follow_user (
    IN p_follower_id INT,
    IN p_followed_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        INSERT INTO follow_log(follower_id, followed_id, error_message)
        VALUES (p_follower_id, p_followed_id, 'SQL Exception');
    END;

    IF p_follower_id = p_followed_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể tự follow chính mình';
    END IF;

    IF (SELECT COUNT(*) FROM users WHERE user_id = p_follower_id) = 0
       OR (SELECT COUNT(*) FROM users WHERE user_id = p_followed_id) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Người dùng không tồn tại';
    END IF;

    IF EXISTS (
        SELECT 1 FROM followers
        WHERE follower_id = p_follower_id
          AND followed_id = p_followed_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Đã follow trước đó';
    END IF;

    START TRANSACTION;

        INSERT INTO followers (follower_id, followed_id)
        VALUES (p_follower_id, p_followed_id);

        UPDATE users
        SET following_count = following_count + 1
        WHERE user_id = p_follower_id;

        UPDATE users
        SET followers_count = followers_count + 1
        WHERE user_id = p_followed_id;

    COMMIT;
END //

DELIMITER ;
CALL sp_follow_user(1, 2);

ALTER TABLE posts
ADD comments_count INT DEFAULT 0;

CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

DELIMITER //

CREATE PROCEDURE sp_post_comment (
    IN p_post_id INT,
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    IF p_content IS NULL OR TRIM(p_content) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nội dung bình luận không hợp lệ';
    END IF;

    IF (SELECT COUNT(*) FROM posts WHERE post_id = p_post_id) = 0
       OR (SELECT COUNT(*) FROM users WHERE user_id = p_user_id) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bài viết hoặc người dùng không tồn tại';
    END IF;

    START TRANSACTION;

        INSERT INTO comments (post_id, user_id, content)
        VALUES (p_post_id, p_user_id, p_content);
        SAVEPOINT after_insert;

        UPDATE posts
        SET comments_count = comments_count + 1
        WHERE post_id = p_post_id;

    COMMIT;
END //

DELIMITER ;

CALL sp_post_comment(1, 1, 'Bình luận hợp lệ');
