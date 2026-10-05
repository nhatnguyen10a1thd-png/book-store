package nguyen.vn.repository;

import nguyen.vn.model.User_24110288;

import java.sql.*;

public class UserRepository_24110288 implements IUserRepository_24110288 {

    @Override
    public User_24110288 login(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND passwd = ?";
        try (Connection conn = DBContext_24110288.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean register(User_24110288 user) {
        String sql = "INSERT INTO users (email, fullname, phone, passwd) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext_24110288.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getFullname());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getPasswd());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public User_24110288 getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DBContext_24110288.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private User_24110288 mapUser(ResultSet rs) throws SQLException {
        User_24110288 user = new User_24110288();
        user.setId(rs.getInt("id"));
        user.setEmail(rs.getString("email"));
        user.setFullname(rs.getString("fullname"));
        user.setPhone(rs.getString("phone"));
        user.setPasswd(rs.getString("passwd"));
        user.setSignupDate(rs.getTimestamp("signup_date"));
        user.setLastLogin(rs.getTimestamp("last_login"));
        user.setAdmin(rs.getBoolean("is_admin"));
        return user;
    }
}
