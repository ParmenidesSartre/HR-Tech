const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const { db } = require("../db/database");

exports.login = async (req, res) => {
  const { email, password } = req.body;
  db.get("SELECT * FROM USERS WHERE EMAIL = ?", [email], (err, user) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (user) {
      bcrypt.compare(password, user.PASSWORD, (err, result) => {
        if (result) {
          const token = jwt.sign(
            { userID: user.USERID, email: user.EMAIL },
            process.env.JWT_SECRET,
            { expiresIn: "1h" }
          );
          res.json({ message: "Login successful", token });
        } else {
          res.status(401).json({ message: "Password is incorrect" });
        }
      });
    } else {
      res.status(404).json({ message: "User not found" });
    }
  });
};

exports.register = async (req, res) => {
  const {
    firstName,
    lastName,
    email,
    password,
    phoneNumber,
    jobTitle,
    department,
    hireDate,
    status,
    roleId,
  } = req.body;

  db.get(
    "SELECT EMAIL FROM USERS WHERE EMAIL = ?",
    [email],
    async (err, row) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }
      if (row) {
        return res.status(409).json({ message: "Email already in use" });
      }

      // If email does not exist, hash the password and insert the new user into the database
      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(password, salt);

      const sql = `
      INSERT INTO USERS (FIRSTNAME, LASTNAME, EMAIL, PASSWORD, PHONENUMBER, JOBTITLE, DEPARTMENT, HIREDATE, STATUS, ROLEID)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;

      db.run(
        sql,
        [
          firstName,
          lastName,
          email,
          hashedPassword,
          phoneNumber,
          jobTitle,
          department,
          hireDate,
          status,
          roleId,
        ],
        function (err) {
          if (err) {
            return res.status(500).json({ error: err.message });
          }
          res.status(201).json({
            message: "User registered successfully",
            userId: this.lastID,
          });
        }
      );
    }
  );
};

exports.getUserInfo = async (req, res) => {
  const { userID } = req.user;
  db.get("SELECT * FROM USERS WHERE USERID = ?", [userID], (err, user) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (user) {
      res.json(user);
    } else {
      res.status(404).json({ message: "User not found" });
    }
  });
};

exports.updateUserInfo = async (req, res) => {
  const { userID } = req.user;
  const {
    firstName,
    lastName,
    email,
    phoneNumber,
    jobTitle,
    department,
    hireDate,
    status,
    roleId,
  } = req.body;

  // Build the SQL query dynamically based on provided fields
  let query = "UPDATE USERS SET ";
  let queryParams = [];
  let fieldsToUpdate = [];

  if (firstName !== undefined) {
    fieldsToUpdate.push("FIRSTNAME = ?");
    queryParams.push(firstName);
  }
  if (lastName !== undefined) {
    fieldsToUpdate.push("LASTNAME = ?");
    queryParams.push(lastName);
  }
  if (email !== undefined) {
    fieldsToUpdate.push("EMAIL = ?");
    queryParams.push(email);
  }
  if (phoneNumber !== undefined) {
    fieldsToUpdate.push("PHONENUMBER = ?");
    queryParams.push(phoneNumber);
  }
  if (jobTitle !== undefined) {
    fieldsToUpdate.push("JOBTITLE = ?");
    queryParams.push(jobTitle);
  }
  if (department !== undefined) {
    fieldsToUpdate.push("DEPARTMENT = ?");
    queryParams.push(department);
  }
  if (hireDate !== undefined) {
    fieldsToUpdate.push("HIREDATE = ?");
    queryParams.push(hireDate);
  }
  if (status !== undefined) {
    fieldsToUpdate.push("STATUS = ?");
    queryParams.push(status);
  }
  if (roleId !== undefined) {
    fieldsToUpdate.push("ROLEID = ?");
    queryParams.push(roleId);
  }

  if (fieldsToUpdate.length === 0) {
    return res.status(400).json({ message: "No fields provided for update" });
  }

  query += fieldsToUpdate.join(", ");
  query += " WHERE USERID = ?";
  queryParams.push(userID);

  db.run(query, queryParams, function (err) {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (this.changes === 0) {
      return res
        .status(404)
        .json({ message: "User not found or no changes made" });
    }
    res.json({ message: "User updated successfully" });
  });
};

exports.deleteUser = async (req, res) => {
  const { userID } = req.user;
  db.run("DELETE FROM USERS WHERE USERID = ?", [userID], function (err) {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (this.changes === 0) {
      return res.status(404).json({ message: "User not found" });
    }
    res.json({ message: "User deleted successfully" });
  });
};
