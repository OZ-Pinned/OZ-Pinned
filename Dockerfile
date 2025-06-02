# 1. Node 이미지 사용
FROM node:18

# 2. 작업 디렉토리 생성
WORKDIR /app

# 3. package.json과 lock 파일 복사
COPY package*.json ./

# 4. 의존성 설치
RUN npm install

# 5. 소스 전체 복사
COPY . .

# 6. NestJS 빌드 (제일 중요!!)
RUN npm run build

# 7. 앱 실행 (빌드된 dist/main.js 실행)
CMD ["npm", "run", "start:prod"]