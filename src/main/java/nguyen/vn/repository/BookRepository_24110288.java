package nguyen.vn.repository;

import nguyen.vn.model.Book_24110288;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookRepository_24110288 implements IBookRepository_24110288 {

    @Override
    public List<Book_24110288> getAllBooks() {
        List<Book_24110288> list = new ArrayList<>();
        String sql = "SELECT * FROM books";
        try (Connection conn = DBContext_24110288.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapBook(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Book_24110288 getBookById(int bookId) {
        String sql = "SELECT b.*, " +
                     "(SELECT STRING_AGG(a.author_name, ', ') FROM author a INNER JOIN book_author ba ON a.author_id = ba.author_id WHERE ba.bookid = b.bookid) as authorNames, " +
                     "(SELECT COUNT(*) FROM rating r WHERE r.bookid = b.bookid) as reviewCount " +
                     "FROM books b WHERE b.bookid = ?";
        try (Connection conn = DBContext_24110288.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBook(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Book_24110288> getBooksByPage(int offset, int limit) {
        List<Book_24110288> list = new ArrayList<>();
        String sql = "SELECT b.*, " +
                     "(SELECT STRING_AGG(a.author_name, ', ') FROM author a INNER JOIN book_author ba ON a.author_id = ba.author_id WHERE ba.bookid = b.bookid) as authorNames, " +
                     "(SELECT COUNT(*) FROM rating r WHERE r.bookid = b.bookid) as reviewCount " +
                     "FROM books b " +
                     "ORDER BY b.bookid " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = DBContext_24110288.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBook(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int getTotalBooks() {
        String sql = "SELECT COUNT(*) FROM books";
        try (Connection conn = DBContext_24110288.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public boolean addBook(Book_24110288 book) {
        String sql = "INSERT INTO books (isbn, title, publisher, price, description, publish_date, cover_image, quantity) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext_24110288.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, book.getIsbn());
                ps.setString(2, book.getTitle());
                ps.setString(3, book.getPublisher());
                ps.setBigDecimal(4, book.getPrice());
                ps.setString(5, book.getDescription());
                if (book.getPublishDate() != null) {
                    ps.setDate(6, new java.sql.Date(book.getPublishDate().getTime()));
                } else {
                    ps.setNull(6, java.sql.Types.DATE);
                }
                ps.setString(7, book.getCoverImage());
                ps.setInt(8, book.getQuantity());
                
                int affectedRows = ps.executeUpdate();
                if (affectedRows == 0) {
                    conn.rollback();
                    return false;
                }
                
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        book.setBookId(generatedKeys.getInt(1));
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
                
                // insert book_author mapping
                if (book.getAuthorIds() != null && book.getAuthorIds().length > 0) {
                    String authorSql = "INSERT INTO book_author (bookid, author_id) VALUES (?, ?)";
                    try (PreparedStatement psAuth = conn.prepareStatement(authorSql)) {
                        for (int authorId : book.getAuthorIds()) {
                            psAuth.setInt(1, book.getBookId());
                            psAuth.setInt(2, authorId);
                            psAuth.addBatch();
                        }
                        psAuth.executeBatch();
                    }
                }
                
                conn.commit();
                return true;
            } catch (SQLException ex) {
                conn.rollback();
                ex.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updateBook(Book_24110288 book) {
        String sql = "UPDATE books SET isbn = ?, title = ?, publisher = ?, price = ?, description = ?, publish_date = ?, cover_image = ?, quantity = ? WHERE bookid = ?";
        try (Connection conn = DBContext_24110288.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, book.getIsbn());
                ps.setString(2, book.getTitle());
                ps.setString(3, book.getPublisher());
                ps.setBigDecimal(4, book.getPrice());
                ps.setString(5, book.getDescription());
                if (book.getPublishDate() != null) {
                    ps.setDate(6, new java.sql.Date(book.getPublishDate().getTime()));
                } else {
                    ps.setNull(6, java.sql.Types.DATE);
                }
                ps.setString(7, book.getCoverImage());
                ps.setInt(8, book.getQuantity());
                ps.setInt(9, book.getBookId());
                
                ps.executeUpdate();
                
                // delete old book_author mappings
                String deleteAuthSql = "DELETE FROM book_author WHERE bookid = ?";
                try (PreparedStatement psDel = conn.prepareStatement(deleteAuthSql)) {
                    psDel.setInt(1, book.getBookId());
                    psDel.executeUpdate();
                }
                
                // insert new book_author mappings
                if (book.getAuthorIds() != null && book.getAuthorIds().length > 0) {
                    String insertAuthSql = "INSERT INTO book_author (bookid, author_id) VALUES (?, ?)";
                    try (PreparedStatement psAuth = conn.prepareStatement(insertAuthSql)) {
                        for (int authorId : book.getAuthorIds()) {
                            psAuth.setInt(1, book.getBookId());
                            psAuth.setInt(2, authorId);
                            psAuth.addBatch();
                        }
                        psAuth.executeBatch();
                    }
                }
                
                conn.commit();
                return true;
            } catch (SQLException ex) {
                conn.rollback();
                ex.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean deleteBook(int bookId) {
        try (Connection conn = DBContext_24110288.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // delete related rating
                String delRatingSql = "DELETE FROM rating WHERE bookid = ?";
                try (PreparedStatement ps = conn.prepareStatement(delRatingSql)) {
                    ps.setInt(1, bookId);
                    ps.executeUpdate();
                }
                
                // delete related book_author
                String delAuthorSql = "DELETE FROM book_author WHERE bookid = ?";
                try (PreparedStatement ps = conn.prepareStatement(delAuthorSql)) {
                    ps.setInt(1, bookId);
                    ps.executeUpdate();
                }
                
                // delete book
                String sql = "DELETE FROM books WHERE bookid = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, bookId);
                    ps.executeUpdate();
                }
                
                conn.commit();
                return true;
            } catch (SQLException ex) {
                conn.rollback();
                ex.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Book_24110288 mapBook(ResultSet rs) throws SQLException {
        Book_24110288 book = new Book_24110288();
        book.setBookId(rs.getInt("bookid"));
        book.setIsbn(rs.getString("isbn"));
        book.setTitle(rs.getString("title"));
        book.setPublisher(rs.getString("publisher"));
        book.setPrice(rs.getBigDecimal("price"));
        book.setDescription(rs.getString("description"));
        book.setPublishDate(rs.getDate("publish_date"));
        book.setCoverImage(rs.getString("cover_image"));
        book.setQuantity(rs.getInt("quantity"));
        try {
            book.setAuthorNames(rs.getString("authorNames"));
        } catch (SQLException e) {
            // ignore
        }
        try {
            book.setReviewCount(rs.getInt("reviewCount"));
        } catch (SQLException e) {
            // ignore
        }
        return book;
    }
}
