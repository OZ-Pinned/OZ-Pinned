const express = require('express');
const router = express.Router();
const cors = require('cors');
const bodyParser = require('body-parser');
const UserDB = require('./models/user_model'); // 예시, 실제 경로로 수정 필요

router.use(cors());
router.use(bodyParser.json());

router.post('/signup', async (req, res) => {
  const { _id, email, name, character } = req.body;

  try {
    const existingUser = await UserDB.findOne({ email }).exec();
    if (existingUser) {
      return res
        .status(400)
        .json({ success: false, errorMessage: 'Email already exists' });
    }

    const createdUser = await UserDB.create({
      _id,
      email,
      name,
      character,
    });

    return res.status(201).json({ success: true, token, user: createdUser });
  } catch (error) {
    return res.status(500).json({ success: false, errorMessage: 'Signup failed' });
  }
});

// 사용자 로그인 라우트
router.post('/login', async (req, res) => {
  const { email } = req.body;

  try {
    // 데이터베이스에서 이메일로 사용자 찾기
    const user = await UserDB.findOne({ email }).exec();

    if (user) {
      return res.status(200).json({
        success: true,
        message: 'Login successful',
        user: {
          id: user._id,
          email: user.email,
          name: user.name,
          character : user.character
        },
      });
    } else {
      // 사용자 계정이 없을 경우
      return res.status(404).json({
        success: false,
        message: 'There is no account with this email',
      });
    }
  } catch (error) {
    console.error('Login error:', error);
    return res.status(500).json({
      success: false,
      message: 'Internal server error during login',
    });
  }
});

module.exports = router;
