// Import mongoose
const mongoose = require("mongoose");
const { Schema } = mongoose;

// Define chatbot schema
const chatbotSchema = new Schema(
  {
    _id: {
      type: Number, // Auto-increment functionality can be managed via a plugin or manually
      required: true,
      unique: true,
    },
    email: {
      type: String, // Foreign key-like field for user association
      required: true,
    },
    sender: {
      type: String, // Name or identifier of the message sender
      required: true,
    },
    message: {
      type: String, // Content of the chat message
      required: true,
    },
  },
  {
    timestamps: { createdAt: true, updatedAt: false }, // Automatically handle createdAt field
  }
);

// Create model
const chatbotModel = mongoose.model("chatbot", chatbotSchema);

// Export the model
module.exports = chatbotModel;
