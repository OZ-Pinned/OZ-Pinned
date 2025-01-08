const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const secretKey = process.env.JWT_SECRET_KEY;

router.post('/user/signup', async (req, res) => {
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

    // JWT 토큰 생성
    const payload = { email, role: 'EMAIL' };
    const token = jwt.sign(payload, secretKey, { expiresIn: '1h' }); // 토큰 유효 시간 1시간

    return res.status(201).json({ success: true, token, user: createdUser });
  } catch (error) {
    return res.status(500).json({ success: false, errorMessage: 'Signup failed' });
  }
});

// 사용자 로그인 라우트
router.post('/login', async (req, res) => {
  // 로그인 로직 구현
});

module.exports = router;
