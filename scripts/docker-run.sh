docker build -t nodeapp:latest ./app
docker run --env-file .env -p 3000:3000 --expose 3000 nodeapp:latest