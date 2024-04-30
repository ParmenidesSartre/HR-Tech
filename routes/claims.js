const express = require("express");
const router = express.Router();
const {
  getClaims,
  submitClaim,
  updateClaim,
  approveClaim,
} = require("../controllers/claimsController");
const { authenticateToken } = require("../utils/authMiddleware");

router.get("/:userId", authenticateToken, getClaims);
router.post("/submit", authenticateToken, submitClaim);
router.put("/:claimId/update", authenticateToken, updateClaim);
router.post("/:claimId/approve", authenticateToken, approveClaim);

module.exports = router;
