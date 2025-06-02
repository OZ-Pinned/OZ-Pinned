const express = require("express");
const mongoose = require("mongoose");
const router = express.Router();
const cors = require("cors");
const bodyParser = require("body-parser");
const UserDB = require("../models/user_model"); // UserDB 모델 가져오기
const { sign } = require("../../auth/jwt-util");
const authJWT = require("../middleware/authJWT");

router.use(cors());
router.use(bodyParser.json());

// 사용자 회원가입 라우트
router.post("/signup", async (req, res) => {
  const { email, name, character } = req.body;

  try {
    // 기존 사용자 이메일 중복 확인
    const existingUser = await UserDB.findOne({ email }).exec();
    if (existingUser) {
      return res
        .status(400)
        .json({ success: false, errorMessage: "Email already exists" });
    }

    // 사용자 생성
    const createdUser = await UserDB.create({
      email,
      name,
      character,
    });

    // 응답: 생성된 사용자 정보 (id 포함)
    return res
      .status(201)
      .json({ success: true, message: "Signup successful", user: createdUser });
  } catch (error) {
    console.error("Signup error:", error);
    return res.status(500).json({
      success: false,
      errorMessage: "Signup failed. Please try again.",
    });
  }
});

// 사용자 로그인 라우트
router.post("/login", async (req, res) => {
  const { email } = req.body;

  try {
    // 데이터베이스에서 이메일로 사용자 찾기
    const user = await UserDB.findOne({ email }).exec();

    console.log(user);

    if (user) {
      const token = sign({ id: user._id, email: user.email });
      console.log(token);
      // 로그인 성공
      return res.status(200).json({
        success: true,
        message: "Login successful",
        user: {
          id: user._id, // MongoDB의 _id는 자동 생성됨
          email: user.email,
          name: user.name,
          character: user.character,
        },
        token,
      });
    } else {
      // 사용자 계정이 없을 경우
      return res.status(404).json({
        success: false,
        message: "There is no account with this email",
      });
    }
  } catch (error) {
    console.error("Login error:", error);
    return res.status(500).json({
      success: false,
      message: "Internal server error during login",
    });
  }
});

module.exports = router;
