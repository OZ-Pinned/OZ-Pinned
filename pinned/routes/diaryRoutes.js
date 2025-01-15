const express = require('express');
const mongoose = require('mongoose');
const router = express.Router();
const cors = require('cors');
const bodyParser = require('body-parser');
const DiaryDB = require('../lib/models/diary_model'); // UserDB 모델 가져오기

router.use(cors());
router.use(bodyParser.json());

router.post('/upload', async (req, res) => {
    const { email, title, diary, image, createdAt, color  } = req.body;
    
    try {
      // 다이어리 생성
      const createdDiary = await DiaryDB.create({
        email,
        title,
        diary,
        image,
        createdAt,
        color
      });
  
      return res.status(201).json({ success: true, diary: createdDiary });
    } catch (error) {
      return res.status(401).json({ success: false, errorMessage: 'Invalid or expired token' });
    }
});
  

// 이메일을 URL 파라미터로 받아오는 라우트 설정
router.get('/get/:email', async (req, res) => {
    const { email } = req.params;

    try {
        const diary = await DiaryDB.find({ email });
        if (diary.length === 0) {  // find는 배열을 반환하므로, diary가 비어있는지 확인
            return res.status(404).json({ success: false, message: 'Diary not found' });
        }
        return res.status(200).json({ success: true, diary });
    } catch (error) {
        return res.status(500).json({ success: false, message: 'Server error', error: error.message });
    }
});


// 이메일로 사용자의 다이어리를 찾아 삭제하는 API
router.delete('/delete/:email', async (req, res) => {
    const { email } = req.params;
    try {
        // 사용자의 이메일로 다이어리를 검색하여 삭제
        const result = await DiaryDB.deleteOne({ email: email });
        if (result.deletedCount === 0) {
            return res.status(404).json({ success: false, message: 'No diary found for this email' });
        }
        return res.status(200).json({ success: true, diary: diaries.map(diary => ({
            ...diary.toObject(),
            _id: diary._id.toString(), // _id를 문자열로 변환
          })),
        });
    } catch (error) {
        return res.status(500).json({ success: false, message: 'Failed to delete diary', error: error.message });
    }
});

router.patch('/edit', async (req, res) => {
    const { email, _id, color } = req.body;

    if (!email || !_id || !color) {
        return res.status(400).json({ success: false, message: 'Email, diaryId, and color are required' });
    }

    try {
        const updatedDiary = await DiaryDB.findOneAndUpdate(
            { email, _id: _id }, // 조건: 이메일과 다이어리 ID가 일치
            { $set: { color } }, // 업데이트: color 필드 변경
            { new: true } // 업데이트 후 변경된 다이어리 반환
        );

        if (!updatedDiary) {
            return res.status(404).json({ success: false, message: 'Diary not found' });
        }

        return res.status(200).json({ success: true, diary: updatedDiary });
    } catch (error) {
        return res.status(500).json({ success: false, message: 'Failed to update diary', error: error.message });
    }
});



module.exports = router;
