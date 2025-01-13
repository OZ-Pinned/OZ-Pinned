const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  id : {type: Number , required: true},
  email: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  character: { type: Number, required: true },
});

module.exports = mongoose.model('UserDB', UserSchema);

const User = mongoose.model('User', UserSchema);

// 예시로 user 생성
const newUser = new User({
  id: 4,  // id 필드를 제공해야 합니다.
  name: "John Doe",
  email: "johndoe@example.com",
  character : 2
});

newUser.save()
  .then((user) => {
    console.log("새로운 사용자 저장:", user);
  })
  .catch((error) => {
    console.error("사용자 저장 실패:", error);
  });