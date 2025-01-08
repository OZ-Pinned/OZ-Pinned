const { MongoClient, ServerApiVersion } = require("mongodb");
require('dotenv').config();

const client = new MongoClient(process.env.uri, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  },
});

const connectDB = async () => {
  try {
    // 클라이언트 연결
    await client.connect();

    // Ping 명령어로 연결 확인
    await client.db("admin").command({ ping: 1 });
    console.log("MongoDB 연결 성공!");
  } catch (err) {
    console.error("MongoDB 연결 실패:", err);
  } finally {
    // 필요할 경우 연결 종료
    await client.close();
  }
};

module.exports = connectDB;
