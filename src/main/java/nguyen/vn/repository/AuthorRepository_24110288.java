package nguyen.vn.repository;

import nguyen.vn.model.Author_24110288;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AuthorRepository_24110288 implements IAuthorRepository_24110288 {

    @Override
    public List<Author_24110288> getAllAuthors() {
        List<Author_24110288> list = new ArrayList<>();
        String sql = "SELECT * FROM author";
        try (Connection conn = DBContext_24110288.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapAuthor(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Author_24110288> getAuthorsByPage(int offset, int limit) {
        List<Author_24110288> list = new ArrayList<>();
        String sql = "SELECT * FROM author ORDER BY author_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = DBContext_24110288.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAuthor(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int getTotalAuthors() {
        String sql = "SELECT COUNT(*) FROM author";
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
    public Author_24110288 getAuthorById(int authorId) {
        String sql = "SELECT * FROM author WHERE author_id = ?";
        try (Connection conn = DBContext_24110288.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, authorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAuthor(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean addAuthor(Author_24110288 author) {
        String sql = "INSERT INTO author (author_name, date_of_birth) VALUES (?, ?)";
        try (Connection conn = DBContext_24110288.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, author.getAuthorName());
            if (author.getDateOfBirth() != null) {
                ps.setDate(2, new java.sql.Date(author.getDateOfBirth().getTime()));
            } else {
                ps.setNull(2, java.sql.Types.DATE);
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updateAuthor(Author_24110288 author) {
        String sql = "UPDATE author SET author_name = ?, date_of_birth = ? WHERE author_id = ?";
        try (Connection conn = DBContext_24110288.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, author.getAuthorName());
            if (author.getDateOfBirth() != null) {
                ps.setDate(2, new java.sql.Date(author.getDateOfBirth().getTime()));
            } else {
                ps.setNull(2, java.sql.Types.DATE);
            }
            ps.setInt(3, author.getAuthorId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean deleteAuthor(int authorId) {
        String sql = "DELETE FROM author WHERE author_id = ?";
        try (Connection conn = DBContext_24110288.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, authorId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Author_24110288 mapAuthor(ResultSet rs) throws SQLException {
        Author_24110288 author = new Author_24110288();
        author.setAuthorId(rs.getInt("author_id"));
        author.setAuthorName(rs.getString("author_name"));
        author.setDateOfBirth(rs.getDate("date_of_birth"));
        return author;
    }
}
