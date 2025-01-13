const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  res.send('chatbot!');
});

router.post('/chatbot/save', async (req, res) => {
    const { _id, email, sender, message, createdAt } = req.body;
  
    try {
      const createdChatbot = await ChatbotDB.create({
        _id,
        email,
        sender,
        message,
        createdAt
      });
  
      res.status(201).json({ success: true, message: 'Chatbot saved successfully', chatbot: createdChatbot });
    } catch (error) {
      if (error.code === 11000) { // MongoDB duplicate key error
        return res.status(400).json({ success: false, message: 'A chatbot with this email already exists' });
      }
      res.status(500).json({ success: false, message: 'Failed to save chatbot', error: error.message });
    }
  });

  
  router.get('/chatbot/get', async (req, res) => {
    const { email } = req.query; // email을 쿼리 파라미터로 받음
  
    if (!email) {
      return res.status(400).json({ success: false, message: 'Email is required' });
    }
  
    try {
      // 이메일로 chatbot을 찾음
      const chatbot = await ChatbotDB.findOne({ email }); // findById가 아니라 email로 검색
      if (!chatbot) {
        return res.status(404).json({ success: false, message: 'Chatbot not found' });
      }
      res.status(200).json({ success: true, chatbot });
    } catch (error) {
      res.status(500).json({ success: false, message: 'Server error', error: error.message });
    }
});




module.exports = router;
