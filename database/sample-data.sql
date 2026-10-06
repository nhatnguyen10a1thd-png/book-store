-- SQL Server seed for the bookstore demo. Safe to run more than once.
-- Cover IDs and their ISBNs are recorded in cover-sources.csv.
-- Source: https://covers.openlibrary.org/b/id/<cover_id>-L.jpg
USE BookStore;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    IF NOT EXISTS (SELECT 1 FROM users WHERE email = 'admin@bookstore.vn')
        INSERT INTO users (email, fullname, phone, passwd, is_admin)
        VALUES ('admin@bookstore.vn', N'Quản trị viên', '0900000001', '123456', 1);

    IF NOT EXISTS (SELECT 1 FROM users WHERE email = 'user@bookstore.vn')
        INSERT INTO users (email, fullname, phone, passwd, is_admin)
        VALUES ('user@bookstore.vn', N'Người dùng mẫu', '0900000002', '123456', 0);

    DECLARE @SeedBooks TABLE (
        isbn VARCHAR(20) NOT NULL PRIMARY KEY,
        title VARCHAR(200) NOT NULL,
        publisher VARCHAR(100) NOT NULL,
        price DECIMAL(6,2) NOT NULL,
        description NVARCHAR(MAX) NOT NULL,
        publish_date DATE NULL,
        cover_image VARCHAR(100) NOT NULL,
        quantity INT NOT NULL,
        authors VARCHAR(500) NOT NULL
    );

    INSERT INTO @SeedBooks (isbn, title, publisher, price, description, publish_date, cover_image, quantity, authors)
    VALUES
    ('9780132350884', 'Clean Code', 'Prentice Hall', 42.00, N'Cẩm nang viết mã nguồn rõ ràng, dễ đọc và dễ bảo trì.', '2008-08-01', 'clean-code.jpg', 12, 'Robert C. Martin'),
    ('9780321125217', 'Domain-Driven Design', 'Addison-Wesley', 54.90, N'Thiết kế phần mềm dựa trên mô hình nghiệp vụ và ngôn ngữ chung.', '2003-08-30', 'cover-9780321125217.jpg', 8, 'Eric Evans'),
    ('9780201485677', 'Refactoring', 'Addison-Wesley', 47.50, N'Cải thiện cấu trúc mã nguồn hiện có bằng những bước nhỏ, an toàn.', '1999-07-08', 'cover-9780201485677.jpg', 15, 'Martin Fowler'),
    ('9780201633610', 'Design Patterns', 'Addison-Wesley Professional', 58.00, N'Hệ thống các mẫu thiết kế hướng đối tượng kinh điển.', '1995-01-15', 'cover-9780201633610.jpg', 6, 'Erich Gamma|Richard Helm|Ralph Johnson|John Vlissides'),
    ('9780134685991', 'Effective Java', 'Addison-Wesley Professional', 45.90, N'Những thực hành hiệu quả để viết Java rõ ràng và bền vững.', '2017-12-27', 'cover-9780134685991.jpg', 18, 'Joshua Bloch'),
    ('9780596007126', 'Head First Design Patterns', 'O''Reilly', 39.50, N'Học mẫu thiết kế qua hình minh họa và ví dụ dễ tiếp cận.', NULL, 'cover-9780596007126.jpg', 0, 'Eric Freeman|Elisabeth Robson|Kathy Sierra|Bert Bates'),
    ('9781260440232', 'Java: The Complete Reference', 'McGraw-Hill Education', 52.00, N'Tài liệu tham khảo toàn diện về ngôn ngữ và thư viện Java.', '2018-12-12', 'cover-9781260440232.jpg', 11, 'Herbert Schildt'),
    ('9780135957059', 'The Pragmatic Programmer', 'Pragmatic Bookshelf', 49.90, N'Kỹ năng và tư duy thực tế dành cho người phát triển phần mềm.', '2019-09-15', 'cover-9780135957059.jpg', 14, 'Andy Hunt|Dave Thomas'),
    ('9780735619678', 'Code Complete', 'Microsoft Press', 56.00, N'Hướng dẫn xây dựng phần mềm từ thiết kế đến kiểm thử mã nguồn.', NULL, 'cover-9780735619678.jpg', 4, 'Steve McConnell'),
    ('9780201835953', 'The Mythical Man-Month', 'Addison-Wesley Professional', 34.90, N'Các bài học về tổ chức và quản lý dự án phần mềm quy mô lớn.', NULL, 'cover-9780201835953.jpg', 7, 'Frederick P. Brooks'),
    ('9780131177055', 'Working Effectively with Legacy Code', 'Prentice Hall', 51.00, N'Kỹ thuật thay đổi mã cũ một cách có kiểm soát và dễ kiểm thử.', NULL, 'cover-9780131177055.jpg', 9, 'Michael C. Feathers'),
    ('9780321127426', 'Patterns of Enterprise Application Architecture', 'Addison-Wesley', 59.00, N'Các mẫu kiến trúc cho ứng dụng doanh nghiệp và tầng dữ liệu.', NULL, 'cover-9780321127426.jpg', 5, 'Martin Fowler'),
    ('9780134494166', 'Clean Architecture', 'Pearson', 46.90, N'Nguyên tắc tổ chức hệ thống để phần mềm dễ thay đổi lâu dài.', '2017-09-10', 'cover-9780134494166.jpg', 16, 'Robert C. Martin'),
    ('9780137081073', 'The Clean Coder', 'Prentice Hall', 36.90, N'Bàn về tính chuyên nghiệp và trách nhiệm trong nghề lập trình.', NULL, 'cover-9780137081073.jpg', 0, 'Robert C. Martin'),
    ('9780321146533', 'Test-Driven Development', 'Addison-Wesley', 38.00, N'Giới thiệu vòng lặp kiểm thử trước khi viết mã và cải tiến thiết kế.', NULL, 'cover-9780321146533.jpg', 13, 'Kent Beck'),
    ('9780321601919', 'Continuous Delivery', 'Addison-Wesley Professional', 62.00, N'Xây dựng quy trình phát hành phần mềm nhanh và đáng tin cậy.', NULL, 'cover-9780321601919.jpg', 3, 'Jez Humble|David Farley'),
    ('9781449373320', 'Designing Data-Intensive Applications', 'O''Reilly Media', 64.90, N'Phân tích hệ thống dữ liệu về độ tin cậy, mở rộng và bảo trì.', '2017-04-02', 'cover-9781449373320.jpg', 20, 'Martin Kleppmann'),
    ('9780073523323', 'Database System Concepts', 'McGraw-Hill', 69.00, N'Kiến thức nền tảng về mô hình dữ liệu, truy vấn và giao dịch.', NULL, 'cover-9780073523323.jpg', 6, 'Abraham Silberschatz|Henry F. Korth|S. Sudarshan'),
    ('9781934356555', 'SQL Antipatterns', 'Pragmatic Bookshelf', 43.00, N'Nhận diện và sửa những lỗi thiết kế cơ sở dữ liệu thường gặp.', NULL, 'cover-9781934356555.jpg', 10, 'Bill Karwin'),
    ('9780596520830', 'Learning SQL', 'O''Reilly', 32.00, N'Bắt đầu với câu lệnh SQL, phép nối bảng và truy vấn thực tế.', NULL, 'cover-9780596520830.jpg', 12, 'Alan Beaulieu'),
    ('9781593279509', 'Eloquent JavaScript', 'No Starch Press', 35.90, N'Học JavaScript qua ví dụ và bài tập xây dựng chương trình.', '2018-12-04', 'cover-9781593279509.jpg', 8, 'Marijn Haverbeke'),
    ('9780596517748', 'JavaScript: The Good Parts', 'O''Reilly Media', 29.90, N'Tập trung vào những đặc điểm hữu ích và biểu đạt tốt của JavaScript.', '2008-05-15', 'cover-9780596517748.jpg', 19, 'Douglas Crockford'),
    ('9781118008188', 'HTML and CSS', 'Wiley', 31.50, N'Hướng dẫn trực quan cách xây dựng và trình bày trang web.', NULL, 'cover-9781118008188.jpg', 0, 'Jon Duckett'),
    ('9781449393199', 'CSS: The Definitive Guide', 'O''Reilly Media', 48.00, N'Tra cứu chi tiết bố cục, kiểu chữ và cách trình bày với CSS.', '2017-11-09', 'cover-9781449393199.jpg', 7, 'Eric A. Meyer|Estelle Weyl'),
    ('9781491954621', 'Learning React', 'O''Reilly Media', 41.00, N'Tìm hiểu thành phần, trạng thái và cách xây dựng giao diện React.', '2018-02-09', 'cover-9781491954621.jpg', 15, 'Alex Banks|Eve Porcello'),
    ('9781617292231', 'Grokking Algorithms', 'Manning', 37.50, N'Giải thích thuật toán và cấu trúc dữ liệu qua minh họa dễ hiểu.', NULL, 'cover-9781617292231.jpg', 18, 'Aditya Y. Bhargava'),
    ('9780262033848', 'Introduction to Algorithms', 'MIT Press', 84.00, N'Giáo trình chuyên sâu về thuật toán, phân tích và chứng minh.', NULL, 'cover-9780262033848.jpg', 5, 'Thomas H. Cormen|Charles E. Leiserson|Ronald L. Rivest|Clifford Stein'),
    ('9780201896831', 'The Art of Computer Programming, Volume 2', 'Addison-Wesley', 92.00, N'Tập hai của bộ sách kinh điển, tập trung vào thuật toán số học.', NULL, 'cover-9780201896831.jpg', 2, 'Donald Knuth'),
    ('9780262510875', 'Structure and Interpretation of Computer Programs', 'MIT Press', 53.00, N'Khám phá các ý tưởng nền tảng về cấu trúc và diễn giải chương trình.', '1996-07-25', 'cover-9780262510875.jpg', 10, 'Harold Abelson|Gerald Jay Sussman|Julie Sussman'),
    ('9781942788331', 'Accelerate', 'IT Revolution Press', 40.00, N'Nghiên cứu thực nghiệm về năng lực giao hàng phần mềm và DevOps.', '2018-03-27', 'cover-9781942788331.jpg', 12, 'Nicole Forsgren|Jez Humble|Gene Kim');

    INSERT INTO books (isbn, title, publisher, price, description, publish_date, cover_image, quantity)
    SELECT s.isbn, s.title, s.publisher, s.price, s.description, s.publish_date, s.cover_image, s.quantity
    FROM @SeedBooks AS s
    WHERE NOT EXISTS (SELECT 1 FROM books AS b WITH (UPDLOCK, HOLDLOCK) WHERE b.isbn = s.isbn);

    -- Preserve existing book details and only fill an empty cover.
    UPDATE b
    SET b.cover_image = s.cover_image
    FROM books AS b
    INNER JOIN @SeedBooks AS s ON s.isbn = b.isbn
    WHERE b.cover_image IS NULL OR LTRIM(RTRIM(b.cover_image)) = '';

    INSERT INTO author (author_name, date_of_birth)
    SELECT person.author_name,
           CASE person.author_name
               WHEN 'Robert C. Martin' THEN CONVERT(DATE, '1952-12-05')
               WHEN 'Martin Fowler' THEN CONVERT(DATE, '1963-12-18')
               ELSE NULL
           END
    FROM (
        SELECT DISTINCT CAST(LTRIM(RTRIM(names.value)) AS VARCHAR(100)) AS author_name
        FROM @SeedBooks AS s
        CROSS APPLY STRING_SPLIT(s.authors, '|') AS names
    ) AS person
    WHERE NOT EXISTS (SELECT 1 FROM author AS a WITH (UPDLOCK, HOLDLOCK) WHERE a.author_name = person.author_name);

    INSERT INTO book_author (bookid, author_id)
    SELECT DISTINCT b.bookid, a.author_id
    FROM @SeedBooks AS s
    INNER JOIN books AS b ON b.isbn = s.isbn
    CROSS APPLY STRING_SPLIT(s.authors, '|') AS names
    CROSS APPLY (
        SELECT TOP (1) author_id
        FROM author
        WHERE author_name = LTRIM(RTRIM(names.value))
        ORDER BY author_id
    ) AS a
    WHERE NOT EXISTS (
        SELECT 1 FROM book_author AS ba
        WHERE ba.bookid = b.bookid AND ba.author_id = a.author_id
    );

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
