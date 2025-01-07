const mongoose = require("mongoose");
const { Schema } = mongoose;

const userDBSchema = new Schema(
  {
    _id: {
      type: Number, // Int16Array 대신 Number 사용
      required: true,
      unique: true,
    },
    email: {
      type: String, // email 타입은 String으로 정의
      unique: true,
    },
    name: {
      type: String,
    },
    character: {
      type: Number, // Int16Array 대신 Number 사용
    },
  },
  { timestamps: true } // 생성 및 수정 시간 자동 추가
);

const userDBModel = mongoose.model("userDB", userDBSchema);

module.exports = userDBModel;
