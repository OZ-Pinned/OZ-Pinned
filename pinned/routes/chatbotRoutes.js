const express = require('express');
const mongoose = require('mongoose');
const router = express.Router();
const cors = require('cors');
const bodyParser = require('body-parser');
const ChatbotDB = require('../lib/models/chatbot_model');

router.use(cors());
router.use(bodyParser.json());

router.post('/save', async (req, res) => {
  const { email, sender, message } = req.body;

  try {
    const chatbot = await ChatbotDB.findOne({ email });

    if (!chatbot) {
      // 새로운 챗봇 데이터 생성
      const newChatbot = await ChatbotDB.create({
        email,
        conversations: [{ sender, message }]
      });
      return res.status(201).json({ success: true, message: 'Chatbot created successfully', chatbot: newChatbot });
    } else {
      // 기존 챗봇 데이터에 새로운 대화 추가
      chatbot.conversations.push({ sender, message });
      await chatbot.save();
      return res.status(201).json({ success: true, message: 'Message added successfully', chatbot });
    }
  } catch (error) {
    console.log(error);
    return res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
});
  
router.get('/get/:email', async (req, res) => {
  const { email } = req.params; // URL 파라미터에서 email을 가져옴
    
  try {
    const chatbot = await ChatbotDB.findOne({ email });
    if (!chatbot) {
      return res.status(400).json({ success: false, message: 'chatbot is required' });
    }
    return res.status(200).json({ success: true, chatbot });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error', error: error.message });
  }
});


module.exports = router;
