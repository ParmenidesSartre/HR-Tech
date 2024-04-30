const express = require("express");
const router = express.Router();
const {
  login,
  register,
  getUserInfo,
  updateUserInfo,
  deleteUser,
  changePassword,
  getUserRole,
  updateUserRole,
} = require("../controllers/userController");
const { authenticateToken } = require("../utils/authMiddleware");

router.post("/login", login);
router.post("/register", register);

// User Details
router.get("/", authenticateToken, getUserInfo);
router.put("/", authenticateToken, updateUserInfo);
router.delete("/:userId", authenticateToken, deleteUser);

// // Password Management
// router.post("/change-password", changePassword);

// // Role Management
// router.get("/:userId/role", getUserRole);
// router.put("/:userId/role", updateUserRole);

module.exports = router;
