FROM node:18.13.0-alpine
RUN apk update && apk upgrade && apk add --no-cache git
WORKDIR /usr/src/app
COPY ./pinned/package*.json ./
RUN npm install
COPY ./pinned .
RUN echo "MONGODB_URI=mongodb+srv://pinned:pinneddatabase123@pinned.zae3y.mongodb.net/pinned?retryWrites=true&w=majority&appName=pinned" > .env
 
# Add debugging before start
CMD node -e "console.log('Current directory:', process.cwd()); \
    console.log('Directory contents:', require('fs').readdirSync('.')); \
    console.log('Parent directory contents:', require('fs').readdirSync('..')); \
    console.log('Env file exists?', require('fs').existsSync('.env')); \
    console.log('Mongoose dir contents:', require('fs').readdirSync('./mongoose')); \
    require('dotenv').config(); \
    console.log('Environment variables:', process.env)" \
    && npm start
