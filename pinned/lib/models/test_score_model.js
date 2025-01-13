const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  id : {type: Number , required: true, unique: true},
  email: { type: String, required: true, unique: true },
  name: { type: Number, required: true },
  createdAt: { type: Date, required: true },
});

module.exports = mongoose.model('TestDB', UserSchema);