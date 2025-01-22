const express = require('express');
const mongoose = require('mongoose');
const router = express.Router();
const path = require("path");
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config({ path : '../.env'});

const chatbotDBModel = require('../lib/models/chatbot_model'); // 모델 경로에 맞게 수정

router.use(cors());
router.use(bodyParser.json());
router.use(express.urlencoded({ extended: true }));
router.use(express.json());
router.use(express.static(path.join(__dirname, "public")));

const { GoogleGenerativeAI } = require("@google/generative-ai");

if (!process.env.GEMINI_API_KEY) {
  console.error("error: env file is missing");
  process.exit(1);
} else {
  const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

  router.post('/get', async (req, res) => {
    const { email, msg: userInput, name } = req.body;
  
    try {
      let userConversations = await chatbotDBModel.findOne({ email });
  
      if (!userConversations) {
        userConversations = new chatbotDBModel({ email, conversations: [] });
      }
  
      if (!userConversations.name && /my name is (\w+)/i.test(userInput)) {
        const extractedName = userInput.match(/my name is (\w+)/i)[1];
        userConversations.name = extractedName;
      }
  
      userConversations.conversations.push({
        sender: 'user',
        message: userInput,
        type: userInput.toLowerCase().includes("my name is") ? "name" : "general"
      });
  
      const conversationHistory = userConversations.conversations.map(conv => `${conv.sender}: ${conv.message}`).join('\n');
      const systemPrompt = `You are a compassionate chatbot who deeply empathizes with the user’s emotions and provides sincere advice.

When the user shares their feelings, respond with genuine understanding and acknowledge their emotions.
Offer only one piece of positive advice that feels supportive and achievable.
Avoid any negative or dismissive language.
Keep it simple, kind, and supportive.
If the user requests something unrelated to emotions or asks for something inappropriate, politely decline the request and refocus on emotional support.
Examples:

If the user says, "I feel so tired," respond with empathy and a single piece of advice:
"I’m sorry to hear you’re feeling this way. It’s okay to rest when you need to—sometimes a short break can help recharge your energy."
If the user says, "I’m feeling overwhelmed," respond like this:
"That sounds really hard. Remember, it’s okay to take things one step at a time. What’s one small thing you can do right now to lighten your load?"`;
      const prompt = `${systemPrompt}\n${conversationHistory}\nuser: ${userInput}\nai: `;
  
      const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });
      const response = await model.generateContent([prompt]);
      const aiResponse = response.response.text().trim();
  
      userConversations.conversations.push({ sender: 'ai', message: aiResponse });
  
      if (userConversations.conversations.length > 50) {
        userConversations.conversations = userConversations.conversations.slice(-50);
      }
  
      await userConversations.save();
  
      const greeting = userConversations.name ? `Hello, ${userConversations.name}! ` : '';
      return res.status(201).json({ success: true, res: greeting + aiResponse });
  
    } catch (error) {
      console.log("error generating response:", error);
      res.status(error.status || 500).send("an error occurred while generating the response");
    }
  });
  
}

module.exports = router;
