package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DAO {

    // Kết nối JDBC chung của lớp DAO và các lớp kế thừa.
    protected Connection con;

    // Chỉ sử dụng khi lưu thẻ và hóa đơn trong cùng một giao dịch.
    private static final ThreadLocal<Connection> activeTransaction = new ThreadLocal<>();

    public DAO() throws SQLException {
        Connection current = activeTransaction.get();
        con = current != null ? current : openConnection();
    }

    public static Connection openConnection() throws SQLException {
        String url = setting("LIBMAN_DB_URL", "jdbc:mariadb://localhost:3306/libman5");
        String user = setting("LIBMAN_DB_USER", "root");
        String password = setting("LIBMAN_DB_PASSWORD", "");
        return DriverManager.getConnection(url, user, password);
    }

    private static String setting(String name, String defaultValue) {
        String value = System.getenv(name);
        return value == null || value.isBlank() ? defaultValue : value;
    }

    protected void closeConnection() throws SQLException {
        if (con != null && con != activeTransaction.get()) {
            con.close();
            con = null;
        }
    }

    @FunctionalInterface
    public interface TransactionWork<T> {
        T run() throws Exception;
    }

    public static <T> T inTransaction(TransactionWork<T> operation) throws Exception {
        if (activeTransaction.get() != null) {
            throw new IllegalStateException("Đang thực hiện giao dịch cơ sở dữ liệu");
        }

        try (Connection connection = openConnection()) {
            connection.setAutoCommit(false);
            activeTransaction.set(connection);

            try {
                T result = operation.run();
                connection.commit();
                return result;
            } catch (Exception | Error error) {
                try {
                    connection.rollback();
                } catch (SQLException rollbackError) {
                    error.addSuppressed(rollbackError);
                }
                throw error;
            } finally {
                activeTransaction.remove();
            }
        }
    }
}
