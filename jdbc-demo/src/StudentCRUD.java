import java.sql.*;
import java.util.Scanner;

public class StudentCRUD {

    // Database credentials
    private static final String URL = "jdbc:mysql://localhost:3306/mydb";
    private static final String USER = "root";
    private static final String PASSWORD = "rythm@12";

    // JDBC Connection
    private static Connection connect() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // CREATE
    public static void insertStudent(String name, int age, double marks) {
        String query = "INSERT INTO students (name, age, marks) VALUES (?, ?, ?)";
        try (Connection con = connect();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, name);
            ps.setInt(2, age);
            ps.setDouble(3, marks);
            ps.executeUpdate();
            System.out.println("Student added successfully!");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // READ
    public static void viewStudents() {
        String query = "SELECT * FROM students";
        try (Connection con = connect();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(query)) {
            System.out.println("Student List:");
            while (rs.next()) {
                System.out.printf("ID: %d | Name: %s | Age: %d | Marks: %.2f%n",
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getInt("age"),
                        rs.getDouble("marks"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // UPDATE
    public static void updateStudent(int id, double newMarks) {
        String query = "UPDATE students SET marks = ? WHERE id = ?";
        try (Connection con = connect();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setDouble(1, newMarks);
            ps.setInt(2, id);
            int rows = ps.executeUpdate();
            if (rows > 0)
                System.out.println("Student updated successfully!");
            else
                System.out.println("⚠️ No student found with ID " + id);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // DELETE
    public static void deleteStudent(int id) {
        String query = "DELETE FROM students WHERE id = ?";
        try (Connection con = connect();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            if (rows > 0)
                System.out.println("🗑️ Student deleted successfully!");
            else
                System.out.println("⚠️ No student found with ID " + id);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // MAIN MENU
    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Load JDBC driver
        } catch (ClassNotFoundException e) {
            System.out.println("Driver not found: " + e.getMessage());
            return;
        }

        Scanner sc = new Scanner(System.in);
        while (true) {
            System.out.println("\n=== STUDENT DATABASE MENU ===");
            System.out.println("1. Insert Student");
            System.out.println("2. View Students");
            System.out.println("3. Update Marks");
            System.out.println("4. Delete Student");
            System.out.println("5. Exit");
            System.out.print("Choose an option: ");
            int choice = sc.nextInt();

            switch (choice) {
                case 1 -> {
                    System.out.print("Enter name: ");
                    String name = sc.next();
                    System.out.print("Enter age: ");
                    int age = sc.nextInt();
                    System.out.print("Enter marks: ");
                    double marks = sc.nextDouble();
                    insertStudent(name, age, marks);
                }
                case 2 -> viewStudents();
                case 3 -> {
                    System.out.print("Enter student ID to update: ");
                    int id = sc.nextInt();
                    System.out.print("Enter new marks: ");
                    double marks = sc.nextDouble();
                    updateStudent(id, marks);
                }
                case 4 -> {
                    System.out.print("Enter student ID to delete: ");
                    int id = sc.nextInt();
                    deleteStudent(id);
                }
                case 5 -> {
                    System.out.println(" Exiting...");
                    sc.close();
                    return;
                }
                default -> System.out.println("Invalid choice!");
            }
        }
    }
}

// javac -cp ".:lib/mysql-connector-j-9.5.0.jar" -d bin src/StudentCRUD.java
// java -cp "bin:lib/mysql-connector-j-9.5.0.jar" StudentCRUD

