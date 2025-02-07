require("dotenv").config();

const express = require("express");
const multer = require("multer");
const fs = require("fs");
const path = require("path");
const { S3Client, PutObjectCommand } = require("@aws-sdk/client-s3");
const { Upload } = require("@aws-sdk/lib-storage");
const dotenv = require("dotenv");
const mongoose = require("mongoose");
const router = express.Router();
const cors = require("cors");
const bodyParser = require("body-parser");
const DiaryDB = require("../lib/models/diary_model");

dotenv.config();

// S3 클라이언트 설정
const s3Client = new S3Client({
  region: process.env.AWS_REGION,
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  },
});

// multer 설정
const storage = multer.memoryStorage(); // 메모리 상에 업로드 파일을 저장
const upload = multer({ storage });

router.use(cors());
router.use(bodyParser.json());

router.post("/upload-image", upload.single("image"), async (req, res) => {
  if (!req.file) {
    return res.status(400).send("No file uploaded");
  }

  const uploadParams = {
    Bucket: process.env.AWS_S3_BUCKET, // S3 버킷 이름
    Key: `${Date.now()}_${path.basename(req.file.originalname)}`, // 파일 이름
    Body: req.file.buffer, // 업로드할 파일 데이터
    ContentType: req.file.mimetype, // 파일의 MIME 타입
  };

  const upload = new Upload({
    client: s3Client,
    params: uploadParams,
  });

  try {
    // 파일 업로드 완료 대기
    await upload.done();
    const fileUrl = `https://${process.env.AWS_S3_BUCKET}.s3.amazonaws.com/${uploadParams.Key}`;
    res.status(200).send({ imageUrl: fileUrl }); // S3에서 반환된 이미지 URL
  } catch (error) {
    console.error("업로드 오류:", error);
    res.status(500).send("파일 업로드 실패");
  }
});

router.post("/upload", async (req, res) => {
  const { email, title, diary, image, createdAt, color, emotion } = req.body;

  const newDiary = new DiaryDB({
    email,
    title,
    diary,
    image,
    createdAt,
    color,
    emotion,
  });

  console.log(newDiary);

  try {
    // 다이어리 생성
    await newDiary.save();
    console.log("success");
    return res.status(201).json({ success: true, diary: newDiary });
  } catch (error) {
    return res.status(401).json({ success: false, error: error.message });
  }
});

// 이메일을 URL 파라미터로 받아오는 라우트 설정
router.get("/get/:email", async (req, res) => {
  const { email } = req.params;

  try {
    const diary = await DiaryDB.find({ email });
    if (diary.length === 0) {
      // find는 배열을 반환하므로, diary가 비어있는지 확인
      return res
        .status(404)
        .json({ success: false, message: "Diary not found" });
    }
    return res.status(200).json({ success: true, diary });
  } catch (error) {
    return res
      .status(500)
      .json({ success: false, message: "Server error", error: error.message });
  }
});

// 이메일로 사용자의 다이어리를 찾아 삭제하는 API
router.delete("/delete/:email", async (req, res) => {
  const { email } = req.params;
  try {
    // 사용자의 이메일로 다이어리를 검색하여 삭제
    const result = await DiaryDB.deleteOne({ email: email });
    if (result.deletedCount === 0) {
      return res
        .status(404)
        .json({ success: false, message: "No diary found for this email" });
    }
    return res.status(200).json({
      success: true,
      diary: diaries.map((diary) => ({
        ...diary.toObject(),
        _id: diary._id.toString(), // _id를 문자열로 변환
      })),
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Failed to delete diary",
      error: error.message,
    });
  }
});

router.patch("/edit", async (req, res) => {
  const { email, _id, color } = req.body;

  if (!email || !_id || !color) {
    return res.status(400).json({
      success: false,
      message: "Email, diaryId, and color are required",
    });
  }

  try {
    const updatedDiary = await DiaryDB.findOneAndUpdate(
      { email, _id }, // 조건: 이메일과 다이어리 ID가 일치
      { $set: { color } }, // 업데이트: color 필드 변경
      { new: true } // 업데이트 후 변경된 다이어리 반환
    );

    if (!updatedDiary) {
      return res
        .status(404)
        .json({ success: false, message: "Diary not found" });
    }

    return res.status(200).json({ success: true, diary: updatedDiary });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Failed to update diary",
      error: error.message,
    });
  }
});

module.exports = router;
