/* =========================================================
   DATABASE: BookStore
   SQL SERVER
   ========================================================= */

IF DB_ID('BookStore') IS NULL
BEGIN
    CREATE DATABASE BookStore;
END
GO

USE BookStore;
GO

IF OBJECT_ID('dbo.order_items', 'U') IS NOT NULL
    DROP TABLE dbo.order_items;

IF OBJECT_ID('dbo.orders', 'U') IS NOT NULL
    DROP TABLE dbo.orders;

IF OBJECT_ID('dbo.rating', 'U') IS NOT NULL
    DROP TABLE dbo.rating;

IF OBJECT_ID('dbo.book_author', 'U') IS NOT NULL
    DROP TABLE dbo.book_author;

IF OBJECT_ID('dbo.books', 'U') IS NOT NULL
    DROP TABLE dbo.books;

IF OBJECT_ID('dbo.author', 'U') IS NOT NULL
    DROP TABLE dbo.author;

IF OBJECT_ID('dbo.users', 'U') IS NOT NULL
    DROP TABLE dbo.users;
GO

CREATE TABLE users
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    email VARCHAR(50) NOT NULL,
    fullname NVARCHAR(50) NULL,
    phone VARCHAR(15) NULL,
    passwd VARCHAR(32) NOT NULL,
    signup_date DATETIME NULL DEFAULT GETDATE(),
    last_login DATETIME NULL,
    is_admin BIT NULL DEFAULT 0,
    CONSTRAINT UQ_users_email UNIQUE(email)
);
GO

CREATE TABLE books
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
GO

CREATE TABLE author
(
    author_id INT IDENTITY(1,1) PRIMARY KEY,
    author_name VARCHAR(100) NULL,
    date_of_birth DATE NULL
);
GO

CREATE TABLE book_author
(
    bookid INT NOT NULL,
    author_id INT NOT NULL,
    CONSTRAINT PK_book_author PRIMARY KEY (bookid, author_id),
    CONSTRAINT FK_book_author_books
        FOREIGN KEY (bookid) REFERENCES books(bookid) ON DELETE CASCADE,
    CONSTRAINT FK_book_author_author
        FOREIGN KEY (author_id) REFERENCES author(author_id) ON DELETE CASCADE
);
GO

CREATE TABLE rating
(
    userid INT NOT NULL,
    bookid INT NOT NULL,
    rating TINYINT NULL,
    review_text NVARCHAR(MAX) NULL,
    CONSTRAINT PK_rating PRIMARY KEY (userid, bookid),
    CONSTRAINT FK_rating_users
        FOREIGN KEY (userid) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT FK_rating_books
        FOREIGN KEY (bookid) REFERENCES books(bookid) ON DELETE CASCADE,
    CONSTRAINT CK_rating_value CHECK (rating IS NULL OR rating BETWEEN 1 AND 5)
);
GO

CREATE TABLE orders
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
    CONSTRAINT FK_orders_users FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT CK_orders_total CHECK (total_amount >= 0),
    CONSTRAINT CK_orders_payment_method CHECK (payment_method = 'COD')
);
GO

CREATE TABLE order_items
(
    order_item_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NULL,
    book_title NVARCHAR(200) NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    quantity INT NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL,
    CONSTRAINT FK_order_items_orders
        FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT FK_order_items_books
        FOREIGN KEY (book_id) REFERENCES books(bookid) ON DELETE SET NULL,
    CONSTRAINT CK_order_items_price CHECK (unit_price >= 0),
    CONSTRAINT CK_order_items_quantity CHECK (quantity > 0),
    CONSTRAINT CK_order_items_subtotal CHECK (subtotal >= 0)
);
GO
