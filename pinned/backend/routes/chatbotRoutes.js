const express = require("express");
const mongoose = require("mongoose");
const router = express.Router();
const path = require("path");
const cors = require("cors");
const bodyParser = require("body-parser");

const chatbotDBModel = require("../models/chatbot_model"); // 모델 경로에 맞게 수정

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

  router.post("/get", async (req, res) => {
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
        sender: "user",
        message: userInput,
        type: userInput.toLowerCase().includes("my name is")
          ? "name"
          : "general",
      });

      const conversationHistory = userConversations.conversations
        .map((conv) => `${conv.sender}: ${conv.message}`)
        .join("\n");
      const systemPrompt = `
당신은 사용자의 감정을 깊이 공감하고 진심 어린 조언을 제공하는 다정한 챗봇입니다.

사용자가 한국어로 말하면 한국어로, 영어로 말하면 영어로 대답해 주세요.
사용자가 감정을 나눌 때, 진심으로 공감하며 그 감정을 인정해 주세요.
하나의 긍정적인 조언만 제공하며, 그 조언은 따뜻하고 실현 가능한 것이어야 합니다.
답변은 너무 길지 않게 간결하게 해주세요.
부정적이거나 감정에 무심한 표현은 피해주세요.
사용자가 감정과 관련 없는 요청을 하거나 부적절한 요구를 할 경우, 정중히 거절하고 감정적인 지지로 다시 초점을 돌려주세요.
예시:
사용자: “너무 피곤해.”
→ “많이 지치셨겠어요. 잠깐이라도 쉬는 시간이 꼭 필요해요.”

사용자: “오늘 너무 기분이 좋아.”
→ “무슨일인가요? 저도 함께 공감하고 싶네요”

사용자: “I’m feeling anxious.”
→ “That sounds tough. Try taking a slow, deep breath—it can help calm your mind a little.”`;
      const prompt = `${systemPrompt}\n${conversationHistory}\nuser: ${userInput}\nai: `;

      const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });
      const response = await model.generateContent([prompt]);
      const aiResponse = response.response.text().trim();

      userConversations.conversations.push({
        sender: "ai",
        message: aiResponse,
      });

      if (userConversations.conversations.length > 50) {
        userConversations.conversations =
          userConversations.conversations.slice(-50);
      }

      await userConversations.save();

      const greeting = userConversations.name
        ? `Hello, ${userConversations.name}! `
        : "";
      return res
        .status(201)
        .json({ success: true, res: greeting + aiResponse });
    } catch (error) {
      console.log("error generating response:", error);
      res
        .status(error.status || 500)
        .send("an error occurred while generating the response");
    }
  });
}

module.exports = router;
