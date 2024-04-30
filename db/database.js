const sqlite3 = require("sqlite3").verbose();
const path = require("path");

// Connect to SQLite database
const dbPath = path.resolve(__dirname, "hrClaims.db");
const db = new sqlite3.Database(
  dbPath,
  sqlite3.OPEN_READWRITE | sqlite3.OPEN_CREATE,
  (err) => {
    if (err) {
      console.error("Error opening database", err.message);
    } else {
      console.log("Connected to the SQLite database.");
    }
  }
);

// Function to initialize database
const initDb = () => {
  const sqlScript = path.resolve(__dirname, "initData.sql");
  const sql = require("fs").readFileSync(sqlScript, "utf8");
  db.exec(sql, (err) => {
    if (err) {
      console.error("Could not initialize the database", err.message);
    } else {
      console.log("Database initialized with tables and initial data.");
    }
  });
};

module.exports = { db, initDb };
