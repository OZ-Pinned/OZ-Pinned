const express = require('express');
const mongoose = require('mongoose');
const router = express.Router();
const cors = require('cors');
const bodyParser = require('body-parser');
const chatbotDB = require('../mongoose/models/chatbotDB.model');

router.use(cors());
router.use(bodyParser.json());

router.post('/save', async (req, res) => {

  const { _id, email, sender, message, createdAt } = req.body;

  try {

    const existingUser = await ChatbotDB.findOne({ email });
    if (existingUser) {
      return res.status(400)
      .json({ success: false, message: 'A chatbot with this email already exists' });
    }
    else {
      const createdChatbot = await ChatbotDB.create({
        _id,
        email,
        sender,
        message,
        createdAt
      });
      return res.status(201).json({ success: true, message: 'Chatbot saved successfully', chatbot: createdChatbot });
      }
    } catch (error) {
      console.log(error);
      return res.status(500).json({ success: false, message: 'Server error'});
    }
  });

  
  router.get('/get/:email', async (req, res) => {
    const { email } = req.query; // email을 쿼리 파라미터로 받음
    
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
