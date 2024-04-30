const { db } = require("../db/database");

exports.getClaims = (req, res) => {
  const userId = req.params.userId;
  const sql = "SELECT * FROM Claims WHERE UserID = ?";

  db.all(sql, [userId], (err, claims) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (claims.length === 0) {
      return res
        .status(404)
        .json({ message: "No claims found for this user." });
    }
    res.json(claims);
  });
};

exports.submitClaim = (req, res) => {
  const { claimTypeId, amount, description, urgency, approverIds } = req.body;
  const userId = req.user.userId;
  const submissionDate = new Date().toISOString();
  const statusId = 1; // Assuming '1' is the Pending status

  // Insert the claim
  const claimSql = `
    INSERT INTO Claims (UserID, ClaimTypeID, Amount, SubmissionDate, Description, StatusID, Urgency)
    VALUES (?, ?, ?, ?, ?, ?, ?);
  `;
  db.run(
    claimSql,
    [
      userId,
      claimTypeId,
      amount,
      submissionDate,
      description,
      statusId,
      urgency,
    ],
    function (err) {
      if (err) {
        console.error("Error during claim insertion: ", err);
        return res.status(500).json({ error: err.message });
      }
      const claimId = this.lastID;

      console.log("Claim ID: ", claimId);

      // Sequentially insert each approver into ClaimApprovals
      let errors = [];
      let processed = 0;
      approverIds.forEach((approverId) => {
        const approvalSql = `
        INSERT INTO ClaimApprovals (ClaimID, ApproverID, ApprovalStatus)
        VALUES (?, ?, 'Pending');
      `;
        db.run(approvalSql, [claimId, approverId], function (err) {
          if (err) {
            errors.push(err.message);
          }
          processed++;
          if (processed === approverIds.length) {
            if (errors.length > 0) {
              console.error("Errors during approver insertion: ", errors);
              return res.status(500).json({ errors });
            }
            res.status(201).json({
              message: "Claim and initial approvals set up successfully.",
              claimId,
            });
          }
        });
      });
    }
  );
};

exports.updateClaim = (req, res) => {
  const { claimId, amount, description } = req.body;

  const sql =
    "UPDATE Claims SET Amount = ?, Description = ? WHERE ClaimID = ? AND StatusID = 1";

  db.run(sql, [amount, description, claimId], function (err) {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (this.changes === 0) {
      return res
        .status(404)
        .json({ message: "Claim not found or already in review." });
    }
    res.json({ message: "Claim updated successfully." });
  });
};

exports.getClaimDetails = (req, res) => {
  const claimId = req.params.claimId;
  const sql = "SELECT * FROM Claims WHERE ClaimID = ?";

  db.get(sql, [claimId], (err, claim) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (!claim) {
      return res.status(404).json({ message: "Claim not found." });
    }
    res.json(claim);
  });
};

exports.approveClaim = (req, res) => {
  const { claimId, approverId, approvalStatus, stepId } = req.body;
  const approvalDate = new Date().toISOString();

  // Check if the approver is allowed to approve at this step
  const checkSql = `
      SELECT * FROM ApprovalChainSteps 
      WHERE StepID = ? AND APPROVERID = (SELECT RoleID FROM Users WHERE UserID = ?)
  `;

  db.get(checkSql, [stepId, approverId], (err, step) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    console.log(step);
    if (!step) {
      return res
        .status(403)
        .json({ message: "Unauthorized or invalid approval step." });
    }

    const sql = `
          INSERT INTO ClaimApprovals (ClaimID, ApproverID, StepID, ApprovalDate, ApprovalStatus)
          VALUES (?, ?, ?, ?, ?)
      `;

    db.run(
      sql,
      [claimId, approverId, stepId, approvalDate, approvalStatus],
      function (err) {
        if (err) {
          return res.status(500).json({ error: err.message });
        }
        res.json({
          message: "Claim approved/rejected successfully",
          approvalId: this.lastID,
        });
      }
    );
  });
};

exports.getAllClaims = (req, res) => {
  const sql = "SELECT * FROM Claims";

  db.all(sql, [], (err, claims) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (claims.length === 0) {
      return res.status(404).json({ message: "No claims found." });
    }
    res.json(claims);
  });
};
