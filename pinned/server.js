const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');
const userRoutes = require('./routes/userRoutes');  // userRoutes.js 파일을 불러옵니다
const chatbotRoutes = require('./routes/chatbotRoutes');
const mypageRoutes = require('./routes/mypageRoutes');
const testRoutes = require('./routes/testRoutes');

// Express 앱 초기화
const app = express();
app.use(cors());
app.use(bodyParser.json());

// MongoDB 연결 설정
const mongoURI = 'mongodb://pinnedUser:pinnedPassword@localhost:27017/pinned'; // 새로운 사용자와 비밀번호로 연결
mongoose.connect(mongoURI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('MongoDB 연결 성공'))
  .catch((error) => console.error('MongoDB 연결 실패:', error));


// 라우트 설정
app.use('/user', userRoutes);  // user 관련 API 라우트 연결
app.use('/chatbot', chatbotRoutes);
app.use('/mypage', mypageRoutes);
app.use('/test', testRoutes);

// 서버 포트 설정
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`서버가 http://localhost:${PORT}에서 실행 중입니다.`);
});
