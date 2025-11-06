// mongo_crud_full.js

use("mydb");
db.students.drop();

print("✅ Database ready.");

// CREATE
db.students.insertMany([
  { name: "Rythm", age: 21, marks: 89.5 },
  { name: "Tanish", age: 22, marks: 76.2 },
  { name: "Pruthviraj", age: 23, marks: 82.4 }
]);
print("🟢 Inserted Students: ");
db.students.find().forEach(doc => printjson(doc));

// UPDATE
db.students.updateOne({ name: "Rythm" }, { $set: { marks: 95.0 } });
print("\n🟡 Updated Rythm’s marks: ");
db.students.find().forEach(doc => printjson(doc));

// DELETE
db.students.deleteOne({ name: "Tanish" });
print("\n🔴 Deleted Tanish. Remaining students:");
db.students.find().forEach(doc => printjson(doc));

print("\n🎯 CRUD Operations Completed!");
