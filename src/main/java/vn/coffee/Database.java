package vn.coffee;

import java.sql.*;
import java.nio.charset.StandardCharsets;

public final class Database {
    private Database() {}
    public static String required(String name) {
        String value = System.getenv(name);
        if (value == null || value.isBlank()) throw new IllegalStateException("Missing configuration: " + name);
        return value;
    }
    public static Connection open() throws SQLException {
        return DriverManager.getConnection(required("COFFEE_DB_URL"), required("COFFEE_DB_USER"), required("COFFEE_DB_PASSWORD"));
    }
    public static void initialize() throws Exception {
        Class.forName("org.postgresql.Driver");
        try (Connection c = open(); var stream = Database.class.getResourceAsStream("/schema.sql")) {
            if (stream == null) throw new IllegalStateException("Schema resource missing");
            c.setAutoCommit(false);
            try (Statement s = c.createStatement()) {
                s.execute("SELECT pg_advisory_xact_lock(730612004)");
                s.execute(new String(stream.readAllBytes(), StandardCharsets.UTF_8));
                c.commit();
            }
        }
    }
}
