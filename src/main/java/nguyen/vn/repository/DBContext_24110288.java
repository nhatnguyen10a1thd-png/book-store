package nguyen.vn.repository;

import nguyen.vn.util.SettingsUtil_24110288;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext_24110288 {
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        String url = requireSetting("BOOKSTORE_DB_URL");
        String user = requireSetting("BOOKSTORE_DB_USER");
        String password = requireSetting("BOOKSTORE_DB_PASSWORD");
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(url, user, password);
    }

    private static String requireSetting(String name) throws SQLException {
        String value = SettingsUtil_24110288.get(name);
        if (value == null) {
            throw new SQLException("Thiếu cấu hình " + name + " trong biến môi trường hoặc file .env");
        }
        return value;
    }
}
