import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;



public class Main {
    private static final String url="jdbc:mysql://localhost:3306/mydb";
    private static final String username="root";
    private static final String password="rythm@12";


    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }

        try {
            Connection connection = DriverManager.getConnection(url, username, password);
            Statement statement=connection.createStatement();
            String query= "select * from students";
            ResultSet resultset=statement.executeQuery(query);
            while(resultset.next()){
                int id=resultset.getInt("id");
                String name=resultset.getString("name");
                int age=resultset.getInt("age");
                double marks=resultset.getDouble("marks");
                System.out.println("ID: "+ id);
                System.out.println("Name: " + name);
                System.out.println("Age: " + age);
                System.out.println("Marks: " + marks);
            }

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}
// javac -cp "lib/mysql-connector-j-8.1.0.jar" -d bin src/Main.java
// java -cp "bin:lib/mysql-connector-j-8.1.0.jar" Main
// java -cp ".:bin:lib/mysql-connector-j-8.1.0.jar" Main
