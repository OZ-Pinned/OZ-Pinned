const connectDB = require("./connectDB.js"); // 경로를 connectDB.js로 수정

(async () => {
    await connectDB();

    // 연결 상태 확인
    const mongoose = require("mongoose");
    if (mongoose.connection.readyState === 1) {
        console.log("MongoDB 연결 상태: 연결 완료");
    } else {
        console.log("MongoDB 연결 상태: 연결되지 않음");
    }

    // 연결 종료
    mongoose.connection.close();
})();
