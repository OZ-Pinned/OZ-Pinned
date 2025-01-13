const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  res.send('mypage!');
});

router.get('/mypage/get:email', async (req, res) => {
    try {
      const { email } = req.params;
      const test = await testScoreDB.find({ email });
      if (!test) {
        return res.status(404).json({ success: false, message: 'Test score not found' });
      }
  
      res.status(200).json({ success: true, test });
    } catch (error) {
      res.status(500).json({ success: false, message: 'Server error', error: error.message });
    }
  });
  

  router.patch('/mypage/change:email', async (req, res) => {
    try {
      const { email } = req.params;
      const { character } = req.body;
      const user = await userDB.findOne({ email });
      
          user.updateOne(
              {},
              {"$set" : {"character" : character }} // 필드 내용 변경
          )
  
      res.status(200).json({ success: true, test });
    } catch (error) {
      res.status(500).json({ success: false, message: 'Server error', error: error.message });
    }
  });
  

module.exports = router;
