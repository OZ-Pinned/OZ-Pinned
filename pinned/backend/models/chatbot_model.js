const mongoose = require("mongoose");
const { Schema } = mongoose;

const chatbotDBSchema = new Schema({
  email: {
    type: String,
    required: true,
    unique: true,
  },
  conversations: [
    {
      sender: {
        type: String,
        enum: ["user", "ai"],
        required: true,
      },
      message: {
        type: String,
        required: true,
      },
      createdAt: {
        type: Date,
        default: Date.now,
      },
    },
  ],
});

const chatbotDBModel = mongoose.model("chatbotDB", chatbotDBSchema);

module.exports = chatbotDBModel;
