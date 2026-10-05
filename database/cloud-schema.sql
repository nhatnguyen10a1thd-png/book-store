/*
   Run this script while connected to the target SQL Server database.
   The database itself must already exist. The script is idempotent and
   does not delete existing data.
*/

IF OBJECT_ID('dbo.users', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.users
    (
        id INT IDENTITY(1,1) PRIMARY KEY,
        email VARCHAR(50) NOT NULL,
        fullname NVARCHAR(50) NULL,
        phone VARCHAR(15) NULL,
        passwd VARCHAR(100) NOT NULL,
        signup_date DATETIME NULL DEFAULT GETDATE(),
        last_login DATETIME NULL,
        is_admin BIT NULL DEFAULT 0,
        CONSTRAINT UQ_users_email UNIQUE(email)
    );
END;

IF OBJECT_ID('dbo.books', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.books
    (
        bookid INT IDENTITY(1,1) PRIMARY KEY,
        isbn VARCHAR(20) NULL,
        title VARCHAR(200) NULL,
        publisher VARCHAR(100) NULL,
        price DECIMAL(6,2) NULL,
        description NVARCHAR(MAX) NULL,
        publish_date DATE NULL,
        cover_image VARCHAR(100) NULL,
        quantity INT NULL,
        CONSTRAINT CK_books_price CHECK (price IS NULL OR price >= 0),
        CONSTRAINT CK_books_quantity CHECK (quantity IS NULL OR quantity >= 0)
    );
END;

IF OBJECT_ID('dbo.author', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.author
    (
        author_id INT IDENTITY(1,1) PRIMARY KEY,
        author_name VARCHAR(100) NULL,
        date_of_birth DATE NULL
    );
END;

IF OBJECT_ID('dbo.book_author', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.book_author
    (
        bookid INT NOT NULL,
        author_id INT NOT NULL,
        CONSTRAINT PK_book_author PRIMARY KEY (bookid, author_id),
        CONSTRAINT FK_book_author_books
            FOREIGN KEY (bookid) REFERENCES dbo.books(bookid) ON DELETE CASCADE,
        CONSTRAINT FK_book_author_author
            FOREIGN KEY (author_id) REFERENCES dbo.author(author_id) ON DELETE CASCADE
    );
END;

IF OBJECT_ID('dbo.rating', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.rating
    (
        userid INT NOT NULL,
        bookid INT NOT NULL,
        rating TINYINT NULL,
        review_text NVARCHAR(MAX) NULL,
        CONSTRAINT PK_rating PRIMARY KEY (userid, bookid),
        CONSTRAINT FK_rating_users
            FOREIGN KEY (userid) REFERENCES dbo.users(id) ON DELETE CASCADE,
        CONSTRAINT FK_rating_books
            FOREIGN KEY (bookid) REFERENCES dbo.books(bookid) ON DELETE CASCADE,
        CONSTRAINT CK_rating_value CHECK (rating IS NULL OR rating BETWEEN 1 AND 5)
    );
END;

IF OBJECT_ID('dbo.orders', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.orders
    (
        order_id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT NOT NULL,
        recipient_name NVARCHAR(100) NOT NULL,
        recipient_phone VARCHAR(20) NOT NULL,
        shipping_address NVARCHAR(500) NOT NULL,
        note NVARCHAR(500) NULL,
        total_amount DECIMAL(12,2) NOT NULL,
        payment_method VARCHAR(20) NOT NULL DEFAULT 'COD',
        payment_status VARCHAR(20) NOT NULL DEFAULT 'UNPAID',
        order_status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
        created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
        CONSTRAINT FK_orders_users FOREIGN KEY (user_id) REFERENCES dbo.users(id),
        CONSTRAINT CK_orders_total CHECK (total_amount >= 0),
        CONSTRAINT CK_orders_payment_method CHECK (payment_method = 'COD')
    );
END;

IF OBJECT_ID('dbo.order_items', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.order_items
    (
        order_item_id INT IDENTITY(1,1) PRIMARY KEY,
        order_id INT NOT NULL,
        book_id INT NULL,
        book_title NVARCHAR(200) NOT NULL,
        unit_price DECIMAL(12,2) NOT NULL,
        quantity INT NOT NULL,
        subtotal DECIMAL(12,2) NOT NULL,
        CONSTRAINT FK_order_items_orders
            FOREIGN KEY (order_id) REFERENCES dbo.orders(order_id) ON DELETE CASCADE,
        CONSTRAINT FK_order_items_books
            FOREIGN KEY (book_id) REFERENCES dbo.books(bookid) ON DELETE SET NULL,
        CONSTRAINT CK_order_items_price CHECK (unit_price >= 0),
        CONSTRAINT CK_order_items_quantity CHECK (quantity > 0),
        CONSTRAINT CK_order_items_subtotal CHECK (subtotal >= 0)
    );
END;

IF NOT EXISTS (SELECT 1 FROM dbo.author WHERE author_name = 'Robert C. Martin')
    INSERT INTO dbo.author (author_name, date_of_birth) VALUES ('Robert C. Martin', '1952-12-05');

IF NOT EXISTS (SELECT 1 FROM dbo.author WHERE author_name = 'Eric Evans')
    INSERT INTO dbo.author (author_name, date_of_birth) VALUES ('Eric Evans', NULL);

IF NOT EXISTS (SELECT 1 FROM dbo.author WHERE author_name = 'Martin Fowler')
    INSERT INTO dbo.author (author_name, date_of_birth) VALUES ('Martin Fowler', '1963-12-18');

IF NOT EXISTS (SELECT 1 FROM dbo.books WHERE isbn = '9780132350884')
BEGIN
    INSERT INTO dbo.books (isbn, title, publisher, price, description, publish_date, quantity)
    VALUES ('9780132350884', 'Clean Code', 'Prentice Hall', 42.00,
            N'Cẩm nang viết mã nguồn rõ ràng, dễ đọc và dễ bảo trì.', '2008-08-01', 12);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.books WHERE isbn = '9780321125217')
BEGIN
    INSERT INTO dbo.books (isbn, title, publisher, price, description, publish_date, quantity)
    VALUES ('9780321125217', 'Domain-Driven Design', 'Addison-Wesley', 54.90,
            N'Tiếp cận thiết kế phần mềm dựa trên mô hình nghiệp vụ.', '2003-08-30', 8);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.books WHERE isbn = '9780201485677')
BEGIN
    INSERT INTO dbo.books (isbn, title, publisher, price, description, publish_date, quantity)
    VALUES ('9780201485677', 'Refactoring', 'Addison-Wesley', 47.50,
            N'Kỹ thuật cải thiện thiết kế mã nguồn hiện có một cách an toàn.', '1999-07-08', 15);
END;

INSERT INTO dbo.book_author (bookid, author_id)
SELECT book.bookid, author.author_id
FROM dbo.books AS book
JOIN dbo.author AS author ON author.author_name = 'Robert C. Martin'
WHERE book.isbn = '9780132350884'
  AND NOT EXISTS (
      SELECT 1 FROM dbo.book_author AS link
      WHERE link.bookid = book.bookid AND link.author_id = author.author_id
  );

INSERT INTO dbo.book_author (bookid, author_id)
SELECT book.bookid, author.author_id
FROM dbo.books AS book
JOIN dbo.author AS author ON author.author_name = 'Eric Evans'
WHERE book.isbn = '9780321125217'
  AND NOT EXISTS (
      SELECT 1 FROM dbo.book_author AS link
      WHERE link.bookid = book.bookid AND link.author_id = author.author_id
  );

INSERT INTO dbo.book_author (bookid, author_id)
SELECT book.bookid, author.author_id
FROM dbo.books AS book
JOIN dbo.author AS author ON author.author_name = 'Martin Fowler'
WHERE book.isbn = '9780201485677'
  AND NOT EXISTS (
      SELECT 1 FROM dbo.book_author AS link
      WHERE link.bookid = book.bookid AND link.author_id = author.author_id
  );
