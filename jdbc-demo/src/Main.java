import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class Main {
    public static void main(String[] args) {
        // MySQL connection details
        String url = "jdbc:mysql://localhost:3306/*";
        String user = "root";      // your MySQL username
        String password = "rythm@12";  // your MySQL password

        try {
            // 1. Connect to MySQL server (without specifying database yet)
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);
            Statement stmt = conn.createStatement();

            // 2. Create a new database
            String dbName = "mydatabase";
            stmt.executeUpdate("CREATE DATABASE IF NOT EXISTS " + dbName);
            System.out.println("Database created: " + dbName);

            // 3. Connect to the newly created database
            conn.close();
            conn = DriverManager.getConnection(url + dbName, user, password);
            stmt = conn.createStatement();

            // 4. Create a table
            String createTableSQL = "CREATE TABLE IF NOT EXISTS students (" +
                                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                                    "name VARCHAR(50), " +
                                    "age INT)";
            stmt.executeUpdate(createTableSQL);
            System.out.println("Table 'students' created.");

            // 5. INSERT data
            String insertSQL1 = "INSERT INTO students (name, age) VALUES ('Alice', 21)";
            String insertSQL2 = "INSERT INTO students (name, age) VALUES ('Bob', 22)";
            stmt.executeUpdate(insertSQL1);
            stmt.executeUpdate(insertSQL2);
            System.out.println("Data inserted.");

            // 6. SELECT data
            ResultSet rs = stmt.executeQuery("SELECT * FROM students");
            System.out.println("Students table data:");
            while (rs.next()) {
                System.out.println(rs.getInt("id") + " | " +
                                   rs.getString("name") + " | " +
                                   rs.getInt("age"));
            }

            // 7. UPDATE data
            String updateSQL = "UPDATE students SET age = 23 WHERE name = 'Alice'";
            stmt.executeUpdate(updateSQL);
            System.out.println("Data updated.");

            // 8. DELETE data
            String deleteSQL = "DELETE FROM students WHERE name = 'Bob'";
            stmt.executeUpdate(deleteSQL);
            System.out.println("Data deleted.");

            // 9. SELECT again to see final data
            rs = stmt.executeQuery("SELECT * FROM students");
            System.out.println("Final Students table data:");
            while (rs.next()) {
                System.out.println(rs.getInt("id") + " | " +
                                   rs.getString("name") + " | " +
                                   rs.getInt("age"));
            }

            // 10. Close resources
            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}


// javac -cp "lib/mysql-connector-j-8.1.0.jar" -d bin src/Main.java
// java -cp "bin:lib/mysql-connector-j-8.1.0.jar" Main

