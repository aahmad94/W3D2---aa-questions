DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(100) NOT NULL,
  lname VARCHAR(100) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  body VARCHAR(255) NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,

  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  body VARCHAR(255) NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,

  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL
);


INSERT INTO
  users (fname, lname)
VALUES
  ('Adeel', 'Ahmad');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Why?', 'Cause...', 1);

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (1, 1);

INSERT INTO
  replies (user_id, question_id, parent_id, body)
VALUES
  (1, 1, NULL, "Hello Word!");

INSERT INTO
  replies (user_id, question_id, parent_id, body)
VALUES
  (1, 1, 1, "Hello Word 2!");

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (1, 1);
