# 1단계: Build용 (dependencies 설치만 함)
FROM node:18-alpine as build

WORKDIR /app
COPY package*.json ./

RUN npm install --omit=dev

# 2단계: Run용 (정말 필요한 것만 포함)
FROM node:18-alpine

WORKDIR /app

# 빌드된 node_modules만 복사
COPY --from=build /app/node_modules ./node_modules

# 필요한 소스만 복사 (최소화)
COPY . .

CMD ["node", "server.js"]