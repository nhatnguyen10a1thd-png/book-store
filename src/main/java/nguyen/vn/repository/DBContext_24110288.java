package nguyen.vn.repository;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext_24110288 {
    private static final String DEFAULT_URL = "jdbc:sqlserver://localhost:1433;databaseName=BookStore;encrypt=true;trustServerCertificate=true";
    private static final String DEFAULT_USER = "sa";
    private static final String DEFAULT_PASSWORD = "123";

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        String url = getSetting("BOOKSTORE_DB_URL", DEFAULT_URL);
        String user = getSetting("BOOKSTORE_DB_USER", DEFAULT_USER);
        String password = getSetting("BOOKSTORE_DB_PASSWORD", DEFAULT_PASSWORD);
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(url, user, password);
    }

    private static String getSetting(String name, String defaultValue) {
        String value = System.getenv(name);
        if (value == null || value.isBlank()) {
            value = System.getProperty(name);
        }
        return value == null || value.isBlank() ? defaultValue : value;
    }
}
