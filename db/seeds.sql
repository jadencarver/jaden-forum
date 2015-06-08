\c jaden_forum
TRUNCATE TABLE users, posts, comments RESTART IDENTITY;

INSERT INTO users
  (name, email, password)
VALUES
  ('Jaden', 'jaden@generalassemb.ly', 'password'),
  ('Phil', 'phil@generalassemb.ly', 'password1'),
  ('Dennis', 'dennis@generalassemb.ly', 'password2'),
  ('Anya', 'anya@generalassemb.ly', 'password3')
;

INSERT INTO posts
  (user_id, title, post, created_at)
VALUES
  (1, 'Test Post', 'This is a test!', CURRENT_TIMESTAMP)
;

INSERT INTO comments
  (user_id, post_id, comment, created_at)
VALUES
  (1, 1, 'Test Comment', CURRENT_TIMESTAMP)
;
