// Import mongoose
const mongoose = require("mongoose");
const { Schema } = mongoose;

// Define chatbot schema
const chatbotDBSchema = new Schema(
  {
    email: {
        type: String,
        required: true
      },
      conversations: [{
        sender: String,
        message: String,
        createdAt: { type: Date, default: Date.now }
      }]
  }
);

// 모델 생성
const chatbotDBModel = mongoose.model("chatbotDB", chatbotDBSchema);

// 모델 내보내기
module.exports = chatbotDBModel;
