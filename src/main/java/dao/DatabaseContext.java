package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/** Hạ tầng JDBC và transaction; KHÔNG phải lớp DAO nghiệp vụ trong biểu đồ. */
public final class DatabaseContext {
    private static final ThreadLocal<Connection> TRANSACTION = new ThreadLocal<>();

    private DatabaseContext() {}

    private static String env(String key, String fallback) {
        String value = System.getenv(key);
        return value == null || value.trim().isEmpty() ? fallback : value;
    }

    public static Connection connection() throws SQLException {
        Connection transactional = TRANSACTION.get();
        if (transactional != null) return transactional;
        return DriverManager.getConnection(
            env("LIBMAN_DB_URL", "jdbc:mariadb://localhost:3306/libman5"),
            env("LIBMAN_DB_USER", "root"),
            env("LIBMAN_DB_PASSWORD", "")
        );
    }

    public static void release(Connection connection) throws SQLException {
        if (connection != null && connection != TRANSACTION.get()) connection.close();
    }

    @FunctionalInterface
    public interface TransactionWork<T> { T execute() throws Exception; }

    /** Dùng cùng một Connection trong hai DAO tạo thẻ và tạo hóa đơn. */
    public static <T> T inTransaction(TransactionWork<T> work) throws Exception {
        if (TRANSACTION.get() != null) throw new IllegalStateException("Giao dịch đang hoạt động");
        try (Connection cn = connection()) {
            cn.setAutoCommit(false);
            TRANSACTION.set(cn);
            try {
                T result = work.execute();
                cn.commit();
                return result;
            } catch (Exception | Error ex) {
                try { cn.rollback(); } catch (SQLException rollbackError) { ex.addSuppressed(rollbackError); }
                throw ex;
            } finally {
                TRANSACTION.remove();
                cn.setAutoCommit(true);
            }
        }
    }
}
