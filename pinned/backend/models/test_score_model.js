const mongoose = require("mongoose");

const testScoreSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  scores: [{ score: Number, createdAt: String }], // 점수를 배열로 저장
});

const TestDB = mongoose.model("Test", testScoreSchema);

module.exports = TestDB;
