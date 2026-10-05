USE BookStore;
GO

IF OBJECT_ID('dbo.orders', 'U') IS NULL
BEGIN
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
END
GO

IF OBJECT_ID('dbo.order_items', 'U') IS NULL
BEGIN
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
END
GO
