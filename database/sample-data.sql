USE BookStore;
GO

IF NOT EXISTS (SELECT 1 FROM users WHERE email = 'admin@bookstore.vn')
BEGIN
    INSERT INTO users (email, fullname, phone, passwd, is_admin)
    VALUES (
        'admin@bookstore.vn',
        N'Quản trị viên',
        '0900000001',
        '123456',
        1
    );
END

IF NOT EXISTS (SELECT 1 FROM users WHERE email = 'user@bookstore.vn')
BEGIN
    INSERT INTO users (email, fullname, phone, passwd, is_admin)
    VALUES (
        'user@bookstore.vn',
        N'Người dùng mẫu',
        '0900000002',
        '123456',
        0
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM author WHERE author_name = 'Robert C. Martin')
    INSERT INTO author (author_name, date_of_birth) VALUES ('Robert C. Martin', '1952-12-05');

IF NOT EXISTS (SELECT 1 FROM author WHERE author_name = 'Eric Evans')
    INSERT INTO author (author_name, date_of_birth) VALUES ('Eric Evans', NULL);

IF NOT EXISTS (SELECT 1 FROM author WHERE author_name = 'Martin Fowler')
    INSERT INTO author (author_name, date_of_birth) VALUES ('Martin Fowler', '1963-12-18');
GO

IF NOT EXISTS (SELECT 1 FROM books WHERE isbn = '9780132350884')
BEGIN
    INSERT INTO books (isbn, title, publisher, price, description, publish_date, quantity)
    VALUES (
        '9780132350884',
        'Clean Code',
        'Prentice Hall',
        42.00,
        N'Cẩm nang viết mã nguồn rõ ràng, dễ đọc và dễ bảo trì.',
        '2008-08-01',
        12
    );
END

IF NOT EXISTS (SELECT 1 FROM books WHERE isbn = '9780321125217')
BEGIN
    INSERT INTO books (isbn, title, publisher, price, description, publish_date, quantity)
    VALUES (
        '9780321125217',
        'Domain-Driven Design',
        'Addison-Wesley',
        54.90,
        N'Tiếp cận thiết kế phần mềm dựa trên mô hình nghiệp vụ.',
        '2003-08-30',
        8
    );
END

IF NOT EXISTS (SELECT 1 FROM books WHERE isbn = '9780201485677')
BEGIN
    INSERT INTO books (isbn, title, publisher, price, description, publish_date, quantity)
    VALUES (
        '9780201485677',
        'Refactoring',
        'Addison-Wesley',
        47.50,
        N'Kỹ thuật cải thiện thiết kế mã nguồn hiện có một cách an toàn.',
        '1999-07-08',
        15
    );
END
GO

INSERT INTO book_author (bookid, author_id)
SELECT b.bookid, a.author_id
FROM books b
JOIN author a ON a.author_name = 'Robert C. Martin'
WHERE b.isbn = '9780132350884'
  AND NOT EXISTS (
      SELECT 1 FROM book_author ba
      WHERE ba.bookid = b.bookid AND ba.author_id = a.author_id
  );

INSERT INTO book_author (bookid, author_id)
SELECT b.bookid, a.author_id
FROM books b
JOIN author a ON a.author_name = 'Eric Evans'
WHERE b.isbn = '9780321125217'
  AND NOT EXISTS (
      SELECT 1 FROM book_author ba
      WHERE ba.bookid = b.bookid AND ba.author_id = a.author_id
  );

INSERT INTO book_author (bookid, author_id)
SELECT b.bookid, a.author_id
FROM books b
JOIN author a ON a.author_name = 'Martin Fowler'
WHERE b.isbn = '9780201485677'
  AND NOT EXISTS (
      SELECT 1 FROM book_author ba
      WHERE ba.bookid = b.bookid AND ba.author_id = a.author_id
  );
GO
