const express = require('express');
const router = express.Router();

// 사용자 등록 라우트
router.get('/signup', async (req, res) => {
  // 회원가입 로직 구현
  console.log('signup')
});

// 사용자 로그인 라우트
router.post('/login', async (req, res) => {
  // 로그인 로직 구현
});

module.exports = router;
