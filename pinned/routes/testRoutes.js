const express = require('express');
const mongoose = require('mongoose');
const router = express.Router();
const cors = require('cors');
const bodyParser = require('body-parser');
const UserDB = require('../lib/models/test_score_model'); // UserDB 모델 가져오기

router.use(cors());
router.use(bodyParser.json());

router.post('/save', async (req, res) => {
    const { _id, email, score, datetime } = req.body;

  try {
    const createdTest = await TestDB.create({
      _id,
      email,
      score,
      datetime
    });

    return res.status(201).json({ success: true, createdTest : createdTest });
  } catch (error) {
    return res.status(401).json({ success: false, errorMessage: 'Invalid or expired token' });
  }
})

module.exports = router;