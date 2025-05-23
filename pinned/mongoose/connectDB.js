const { MongoClient, ServerApiVersion } = require("mongodb");
require('dotenv').config();

const uri = "mongodb+srv://pinned:pinneddatabase123@pinned.zae3y.mongodb.net/pinned?retryWrites=true&w=majority&appName=pinned"

const client = new MongoClient(uri, {
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
    const database = client.db("pinned");  // 데이터베이스 선택, 없으면 자동 생성
    const users = database.collection("userDB");  // 컬렉션 선택, 없으면 자동 생성

    // 새로운 사용자 데이터ㄴ
    console.log("MongoDB 연결 성공!");
  } catch (err) {
    console.error("MongoDB 연결 실패:", err);
  } finally { 
    await client.close();
  }
};

module.exports = connectDB;


connectDB().catch(console.error)