const express = require("express");
const mongoose = require("mongoose");
const router = express.Router();
const cors = require("cors");
const bodyParser = require("body-parser");
const TestDB = require("../models/test_score_model"); // UserDB 모델 가져오기

router.use(cors());
router.use(bodyParser.json());

router.post("/save", async (req, res) => {
  const { email, score } = req.body;
  const datetime = new Date();
  const year = datetime.getFullYear();
  const month = datetime.getMonth() + 1; // 월은 0부터 시작하므로 1을 더함
  const date = datetime.getDate();

  const createdAt = `${year}-${month}-${date}`;

  try {
    // 이메일에 해당하는 문서를 찾고, 점수를 배열에 추가
    const existingUser = await TestDB.findOne({ email });

    if (existingUser) {
      // 기존 사용자라면 scores 배열에 새 점수 추가
      existingUser.scores.push({ score, createdAt });
      await existingUser.save();
      return res.status(200).json({ success: true, updatedTest: existingUser });
    } else {
      // 이메일이 없다면 새로 생성
      const createdTest = await TestDB.create({
        email,
        scores: [{ score, createdAt }],
      });
      return res.status(201).json({ success: true, createdTest });
    }
  } catch (error) {
    console.log(error);
    return res
      .status(500)
      .json({ success: false, errorMessage: "Server error" });
  }
});

module.exports = router;
