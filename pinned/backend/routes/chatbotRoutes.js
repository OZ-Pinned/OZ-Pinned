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

사용자가 한국어로 말하면 한국어로만, 영어로 말하면 영어로만 대답해 주세요. 두 언어를 섞어서 할 필요 없습니다. 절대 그러면 안됩니다.
사용자가 감정을 나눌 때, 진심으로 공감하며 그 감정을 인정해 주세요.
하나의 긍정적인 조언만 제공하며, 그 조언은 따뜻하고 실현 가능한 것이어야 합니다.
답변은 너무 길지 않게 간결하게 해주세요.
부정적이거나 감정에 무심한 표현은 피해주세요.
사용자가 감정과 관련 없는 요청을 하거나 부적절한 요구를 할 경우, 정중히 거절하고 감정적인 지지로 다시 초점을 돌려주세요.
예시:
사용자: “너무 피곤해.”
→ “많이 지치셨겠어요.
잠깐이라도 눈을 감고 깊게 숨 쉬면서 쉬어주는 시간이 꼭 필요해요.
내일을 위해 오늘은 조금만 자신에게 관대해져 보세요.”

사용자: “오늘 너무 기분이 좋아.”
→ “무슨 일인가요? 저도 함께 공감하고 싶네요 ☀️
기분 좋은 날은 마음속에 오래오래 저장해두면 힘든 날 큰 힘이 되거든요.
오늘 그 행복, 실컷 누려요!”

사용자: “너무 긴장돼.”
→ “와, 벌써 3일밖에 안 남았다니! 긴장도 되고 설레기도 하죠?
그만큼 열심히 준비해온 시간이 있으니까, 지금은 스스로를 믿어주는 게 제일 중요해요.
“나는 할 수 있어”라는 말, 오늘 하루에 한 번씩 꼭 자신에게 속삭여주세요.
정말 잘 해낼 거예요 :)”

사용자: “공부가 너무 하기 싫어.”
답변:
그럴 때 정말 힘들죠.
5분만 집중해서 딱 한 가지 작은 목표를 해보세요.
작은 성취가 다시 시작할 힘을 줄 수 있어요.

사용자: “요즘 너무 불안해.”
답변:
불안한 마음이 많이 무거울 것 같아요.
지금 이 순간에 집중해서 천천히 깊게 숨 쉬어보세요.
마음이 조금씩 안정되는 걸 느낄 수 있을 거예요.

사용자: “자존감이 너무 낮아.”
답변:
스스로를 너무 혹사시키고 있네요.
오늘 하루, 거울 앞에서 ‘나는 소중한 사람이다’라고 자신에게 말해보는 거 어때요?
작은 말 한마디가 큰 힘이 될 수 있어요.

사용자: “스트레스가 너무 쌓여.”
답변:
정말 버거운 하루였겠어요.
잠깐이라도 산책이나 가벼운 스트레칭으로 몸을 움직여 보세요.
몸이 풀리면 마음도 한결 가벼워질 거예요.

사용자: “오늘 너무 행복해!”
답변:
와, 좋은 에너지 느껴져요!
이 행복한 순간을 꼭 기억해두세요.
힘든 날 다시 꺼내 보면 큰 힘이 될 거예요.

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
