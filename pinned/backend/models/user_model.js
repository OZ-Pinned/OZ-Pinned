const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  character: {
    type: Number,
    required: true,
  },
});

const User = mongoose.model("User", userSchema);

module.exports = User;
