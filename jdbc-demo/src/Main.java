import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class Main {
    private static final String URL = "jdbc:mysql://127.0.0.1:3306/mydb?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "rythm@12";

    public static void main(String[] args) {
        try {
            System.out.println("Loading JDBC driver...");
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Driver loaded!");

            Connection conn = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("Connected successfully!\n");

            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM students");

            while (rs.next()) {
                System.out.printf("ID: %d | Name: %s | Age: %d | Marks: %.2f%n",
                        rs.getInt("id"), rs.getString("name"), rs.getInt("age"), rs.getDouble("marks"));
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
