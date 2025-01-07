const mongoose = require("mongoose");

const connectDB = async () => {
    try {
        mongoose.set("debug", true);

        await mongoose.connect("mongodb://root:591006@localhost:27017/admin", {
            dbName: "userDB",
        });
        console.log("MongoDB 연결 성공");
    } catch (err) {
        console.error("MongoDB 연결 실패:", err);
    }
};

mongoose.connection.on("error", (err) => {
    console.error("MongoDB 연결 에러:", err);
});

mongoose.connection.on("disconnected", () => {
    console.error("MongoDB 연결 해제. 연결 재시도 중...");
    connectDB(); // 재시도
});

module.exports = connectDB;
