import com.mongodb.client.*;
import org.bson.Document;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Updates.set;

public class MongoCRUD {

    public static void main(String[] args) {
        // 1️⃣ Connect to MongoDB
        String uri = "mongodb://localhost:27017";
        try (MongoClient mongoClient = MongoClients.create(uri)) {

            // 2️⃣ Create or Get Database
            MongoDatabase database = mongoClient.getDatabase("mydb");
            System.out.println("✅ Connected to database: " + database.getName());

            // 3️⃣ Create or Get Collection
            MongoCollection<Document> collection = database.getCollection("students");
            System.out.println("✅ Using collection: " + collection.getNamespace());

            // Clear old data for demonstration
            collection.drop();
            System.out.println("🧹 Collection cleared for fresh start.");

            // 4️⃣ CREATE — Insert documents
            Document student1 = new Document("name", "Rythm")
                    .append("age", 21)
                    .append("marks", 89.5);
            Document student2 = new Document("name", "Tanish")
                    .append("age", 22)
                    .append("marks", 76.2);

            collection.insertOne(student1);
            collection.insertOne(student2);
            System.out.println("🟢 Inserted students successfully!");

            // 5️⃣ READ — Display all documents
            System.out.println("\n📋 Student List:");
            for (Document doc : collection.find()) {
                System.out.println(doc.toJson());
            }

            // 6️⃣ UPDATE — Update a student's marks
            collection.updateOne(eq("name", "Rythm"), set("marks", 95.0));
            System.out.println("\n Updated Rythm's marks to 95.0");

            // 7️READ AGAIN
            System.out.println("\n📋 Updated Student List:");
            for (Document doc : collection.find()) {
                System.out.println(doc.toJson());
            }

            // 8️ DELETE — Remove a student
            collection.deleteOne(eq("name", "Tanish"));
            System.out.println("\n🔴 Deleted student: Tanish");

            // 9️Final READ
            System.out.println("\n📋 Final Student List:");
            for (Document doc : collection.find()) {
                System.out.println(doc.toJson());
            }

            System.out.println("\n CRUD operations completed successfully!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
