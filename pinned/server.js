const express = require('express');
const userRoutes = require('./routes/userRoutes'); // 라우트 파일 불러오기

const app = express();
const port = 27017;

app.use(express.json()); // JSON 요청 본문 파싱

// '/user' 경로로 들어오는 요청을 userRoutes 라우터로 처리
app.use('/user', userRoutes);

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
