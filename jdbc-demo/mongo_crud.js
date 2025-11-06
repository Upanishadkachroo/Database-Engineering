// ========================================================
// 🌟 MongoDB Complete CRUD Demonstration
// ========================================================

// 1️⃣ Select or Create Database
use("mydb");

// Drop old collection for a clean start
db.students.drop();
print("✅ Using database: mydb");
print("🧹 Dropped existing 'students' collection (if any).");

// ========================================================
// 🟢 CREATE Operations
// ========================================================

// ➤ insertOne()
db.students.insertOne({ name: "Rythm", age: 21, marks: 89.5 });
print("\n✅ insertOne() -> Inserted one student (Rythm).");

// ➤ insertMany()
db.students.insertMany([
  { name: "Tanish", age: 22, marks: 76.2 },
  { name: "Pruthviraj", age: 23, marks: 82.4 },
  { name: "Ishaan", age: 20, marks: 91.7 },
  { name: "Aditi", age: 22, marks: 88.9 }
]);
print("✅ insertMany() -> Inserted multiple students.");

// Show inserted data
print("\n📋 Students after INSERT operations:");
db.students.find().forEach(doc => printjson(doc));

// ========================================================
// 🔍 READ Operations
// ========================================================

// ➤ find() — all students
print("\n🔍 find() -> All Students:");
db.students.find().forEach(doc => printjson(doc));

// ➤ findOne() — single matching student
print("\n🔍 findOne() -> Student named 'Ishaan':");
printjson(db.students.findOne({ name: "Ishaan" }));

// ➤ find() with condition
print("\n🔍 find() with condition -> Students with marks > 85:");
db.students.find({ marks: { $gt: 85 } }).forEach(doc => printjson(doc));

// ========================================================
// ✏️ UPDATE Operations
// ========================================================

// ➤ updateOne() — update single document
db.students.updateOne(
  { name: "Rythm" },
  { $set: { marks: 95.0 } }
);
print("\n✏️ updateOne() -> Updated marks for Rythm.");

// ➤ updateMany() — increase marks by 5 for all with marks < 85
db.students.updateMany(
  { marks: { $lt: 85 } },
  { $inc: { marks: 5 } }
);
print("✏️ updateMany() -> Increased marks by +5 for students scoring < 85.");

// Show updated results
print("\n📋 Students after UPDATE operations:");
db.students.find().forEach(doc => printjson(doc));

// ========================================================
// ❌ DELETE Operations
// ========================================================

// ➤ deleteOne() — remove one document
db.students.deleteOne({ name: "Tanish" });
print("\n❌ deleteOne() -> Deleted student Tanish.");

// ➤ deleteMany() — remove students below 80 marks
db.students.deleteMany({ marks: { $lt: 80 } });
print("❌ deleteMany() -> Deleted all students with marks < 80.");

// Show remaining data
print("\n📋 Students after DELETE operations:");
db.students.find().forEach(doc => printjson(doc));

// ========================================================
// 🏁 Extra: Count, Sort, and Projection examples
// ========================================================

// ➤ countDocuments()
print("\n🔢 countDocuments() -> Total Students:");
print(db.students.countDocuments());

// ➤ find() with sort
print("\n🔽 find() with sort -> Students sorted by marks descending:");
db.students.find().sort({ marks: -1 }).forEach(doc => printjson(doc));

// ➤ Projection (only show name and marks)
print("\n🎯 Projection -> Only Name and Marks:");
db.students.find({}, { _id: 0, name: 1, marks: 1 }).forEach(doc => printjson(doc));

print("\n🎯 ALL CRUD OPERATIONS + EXTRAS COMPLETED SUCCESSFULLY!");
