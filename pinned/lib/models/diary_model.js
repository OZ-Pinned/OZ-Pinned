const mongoose = require('mongoose');

const diarySchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true, },
  diaries: [{ title: String, diary: String, image: String }]  // 점수를 배열로 저장
});

const DiaryDB = mongoose.model('Diary', diarySchema);

module.exports = DiaryDB;
