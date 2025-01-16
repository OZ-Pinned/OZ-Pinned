const express = require('express');
const mongoose = require('mongoose');
const router = express.Router();
const path = require("path");
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();

router.use(cors());
router.use(bodyParser.json());
router.use(express.urlencoded({extended : true}))
router.use(express.json())
router.use(express.static(path.join(__dirname, "public")))

const { GoogleGenerativeAI } = require("@google/generative-ai");


if(!process.env.GEMINI_API_KEY){
  console.error("error : env file is missing")
  process.exit(1);
} 
else {
  const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

  router.post('/get', async (req, res) => {
      const userInput = req.body.msg

      try {
          // const model = genAI.getGenerativeModel({model : "gemini-1.5-flash"})

          // let prompt = [userInput];

          // const response = await model.generateContent(prompt);
          // console.log(response.response.text())
          return res.status(201).json({success : true, res : '안녕하세요'});

      } catch (error) {
          console.log("error generating response : ", error)
          res.status(error.status || 500).send("an error occurred while generating the response")
      } 
  })
}


module.exports = router;
