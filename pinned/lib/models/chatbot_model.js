const mongoose = require('mongoose');

const chatbotSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true, },
  texts: [{ sender: String, text: String,}]  // 점수를 배열로 저장
});

const ChatbotDB = mongoose.model('Chatbot', chatbotSchema);

module.exports = ChatbotDB;
