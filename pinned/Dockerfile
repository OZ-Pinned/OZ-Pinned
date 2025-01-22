FROM node:18.13.0-alpine
RUN apk update && apk upgrade && apk add --no-cache git
WORKDIR /usr/src/app
COPY ./pinned/package*.json ./
RUN npm install
COPY ./pinned .
RUN echo "MONGODB_URI=mongodb+srv://pinned:pinneddatabase123@pinned.zae3y.mongodb.net/pinned?retryWrites=true&w=majority&appName=pinned" > .env
 
CMD ls -la && pwd && echo "ENV contents:" && cat .env && echo "Starting server..." && NODE_DEBUG=* npm start
