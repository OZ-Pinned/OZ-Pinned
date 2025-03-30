const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const diarySchema = new Schema({
  email: {
    type: String,
    required: true,
    ref: "User", // 'User' 모델과의 관계를 나타내는 외래키
  },
  title: {
    type: String,
    required: true, // 제목 필드는 필수
  },
  diary: {
    type: String,
    required: true, // 다이어리 내용 필드도 필수
  },
  image: {
    type: String, // 이미지 URL은 필수는 아니므로, required 옵션은 X
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now, // 생성 날짜는 문서가 생성될 때 자동으로 설정
  },
  color: {
    type: String,
    required: true,
  },
  emotion: {
    type: Number,
    required: true,
  },
});

const Diary = mongoose.model("Diary", diarySchema);

module.exports = Diary;
