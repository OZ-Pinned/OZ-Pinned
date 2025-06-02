const express = require("express");
const router = express.Router();
const UserDB = require("../models/user_model"); // UserDB 모델 가져오기
const cors = require("cors");
const bodyParser = require("body-parser");

router.use(cors());
router.use(bodyParser.json());

router.get("/get/:email", async (req, res) => {
  try {
    const { email } = req.params;
    const user = await UserDB.findOne({ email });
    console.log(user);
    if (!user) {
      return res
        .status(404)
        .json({ success: false, message: "Test score not found" });
    }
    res.status(200).json({ success: true, user: user });
  } catch (error) {
    res
      .status(500)
      .json({ success: false, message: "Server error", error: error.message });
  }
});

module.exports = router;
