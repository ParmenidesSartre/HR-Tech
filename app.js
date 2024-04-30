const express = require("express");
const claimsRoutes = require("./routes/claims");
const usersRoutes = require("./routes/users");
const { initDb, db } = require("./db/database");
const dotenv = require("dotenv");
const app = express();
const PORT = process.env.PORT || 3000;

dotenv.config();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/api/claims", claimsRoutes);
app.use("/api/users", usersRoutes);

app.listen(PORT, () => {
  initDb();
  console.log(`Server running on port ${PORT}`);
});
