const express = require('express');
const router = express.Router();
const UserDB = require('../lib/models/user_model'); // UserDB 모델 가져오기
const TestDB = require('../lib/models/test_score_model'); // TestDB 모델 가져오기
const cors = require('cors');
const bodyParser = require('body-parser');

router.use(cors());
router.use(bodyParser.json());

router.get('/get/:email', async (req, res) => {
    try {
      const { email } = req.params;
      const test = await TestDB.findOne({ email });
      const user = await UserDB.findOne({ email });
      console.log(test)
      if (!test || !user) {
        return res.status(404).json({ success: false, message: 'Test score not found' });
      }
      res.status(200).json({ success: true, test : test, user : user });
    } catch (error) {
      res.status(500).json({ success: false, message: 'Server error', error: error.message });
    }
  });
  

  router.post('/change/:email', async (req, res) => {
    const { email } = req.params;
    const { character } = req.body; // 변경할 character 값

    // console.log(email, character)
  
    try {
      const existingUser = await UserDB.findOne({ email });
      console.log(existingUser)
      if (!existingUser) {
        return res.status(404).json({ success: false, message: 'User not found' });
      }
  
      // 사용자 캐릭터 업데이트

      console.log("선택된 캐릭터" + character);
      existingUser.character = character;
  
      await existingUser.save(); // 업데이트된 데이터 저장
  
      return res.status(200).json({ 
        success: true, 
        message: 'Character updated successfully', 
        user: existingUser 
      });
      
    } catch (error) {
      console.error('Error updating character:', error);
      return res.status(500).json({ success: false, message: 'Failed to update character', error: error.message });
    }
  });
  

module.exports = router;
