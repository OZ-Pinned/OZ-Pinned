FROM node:18.13.0-alpine
 
RUN apk update && apk upgrade && \
    apk add --no-cache git
 
WORKDIR /usr/src/app
 
COPY ./pinned/package*.json ./
 
RUN npm install
 
COPY ./pinned .

COPY ./pinned/.env .

EXPOSE 42069
 
CMD ["npm", "start"]
