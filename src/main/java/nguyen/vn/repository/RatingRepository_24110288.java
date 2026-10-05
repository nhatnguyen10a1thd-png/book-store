package nguyen.vn.repository;

import nguyen.vn.model.Rating_24110288;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RatingRepository_24110288 implements IRatingRepository_24110288 {

    @Override
    public List<Rating_24110288> getRatingsByBookId(int bookId) {
        List<Rating_24110288> list = new ArrayList<>();
        String sql = "SELECT r.*, u.fullname FROM rating r INNER JOIN users u ON r.userid = u.id WHERE r.bookid = ? ORDER BY r.userid DESC";
        try (Connection conn = DBContext_24110288.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Rating_24110288 rating = new Rating_24110288();
                    rating.setUserId(rs.getInt("userid"));
                    rating.setBookId(rs.getInt("bookid"));
                    rating.setRating(rs.getInt("rating"));
                    rating.setReviewText(rs.getString("review_text"));
                    rating.setFullname(rs.getString("fullname"));
                    list.add(rating);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean addRating(Rating_24110288 rating) {
        String sql = "INSERT INTO rating (userid, bookid, rating, review_text) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext_24110288.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rating.getUserId());
            ps.setInt(2, rating.getBookId());
            ps.setInt(3, rating.getRating());
            ps.setString(4, rating.getReviewText());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
