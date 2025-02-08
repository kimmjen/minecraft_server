# Minecraft Server Setup Guide

## 목차
- [시스템 요구사항](#시스템-요구사항)
- [서버 파일 다운로드](#서버-파일-다운로드)
- [기본 서버 설정](#기본-서버-설정)
- [도커로 실행하기](#도커로-실행하기)
- [IntelliJ IDEA에서 실행하기](#intellij-idea에서-실행하기)
- [서버 명령어](#서버-명령어)
- [서버 설정 파일](#서버-설정-파일)

## 시스템 요구사항
- Java 21 이상
- 최소 4GB RAM
- 마인크래프트 server.jar 파일

## 서버 파일 다운로드

### 공식 다운로드 링크
- [Minecraft 서버 다운로드 페이지](https://www.minecraft.net/ko-kr/download/server)

### 다운로드 방법
1. 위 링크에서 'minecraft_server.1.x.x.jar' 다운로드
2. 다운로드한 파일을 'server.jar'로 이름 변경
3. 원하는 서버 디렉토리에 파일 이동

### 주의사항
- 항상 공식 웹사이트에서 다운로드
- 서버 버전과 클라이언트 버전 일치 확인
- 정기적으로 최신 버전 업데이트 확인

## 기본 서버 설정

### 1. Java 버전 확인
```bash
java -version
```

### 2. 서버 실행
```bash
java -Xmx4G -Xms4G -jar server.jar nogui
```

### 3. EULA 동의
- eula.txt 파일에서 `eula=false`를 `eula=true`로 변경

## 도커로 실행하기

### 1. Dockerfile
```dockerfile
FROM eclipse-temurin:21-jre-jammy

WORKDIR /minecraft

ENV MEMORY_SIZE=4G

RUN apt-get update && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY server.jar /minecraft/server.jar
RUN echo "eula=true" > eula.txt

RUN useradd -r -U -m minecraft && \
    chown -R minecraft:minecraft /minecraft

USER minecraft
EXPOSE 25565

VOLUME ["/minecraft/world", "/minecraft/logs", "/minecraft/config"]

CMD ["sh", "-c", "java -Xmx${MEMORY_SIZE} -Xms${MEMORY_SIZE} -jar server.jar nogui"]
```

### 2. Docker Compose
```yaml
version: '3.8'

services:
  minecraft:
    build: .
    ports:
      - "25565:25565"
    environment:
      - MEMORY_SIZE=4G
      - TZ=Asia/Seoul
    volumes:
      - ./world:/minecraft/world
      - ./logs:/minecraft/logs
      - ./config:/minecraft/config
    restart: unless-stopped
    container_name: minecraft_server
```

### 3. 도커 실행
```bash
docker-compose up -d
```

## IntelliJ IDEA에서 실행하기

1. JAR Application 설정:
    - Run > Edit Configurations
    - '+' 버튼 클릭 > JAR Application 선택
    - Name: Minecraft Server
    - Path to JAR: server.jar 경로
    - VM options: `-Xmx4G -Xms4G`
    - Program arguments: `nogui`

## 서버 명령어

### 기본 명령어
- `/op [플레이어]`: 관리자 권한 부여
- `/gamemode creative/survival [플레이어]`: 게임모드 변경
- `/time set day/night`: 시간 변경
- `/weather clear/rain`: 날씨 변경
- `/difficulty peaceful/easy/normal/hard`: 난이도 변경

## 서버 설정 파일

### server.properties 주요 설정
```properties
# 기본 게임모드
gamemode=survival

# 난이도
difficulty=normal

# 최대 플레이어 수
max-players=20

# PvP 설정
pvp=true

# 온라인 모드 (정품 인증)
online-mode=true
```

## 문제해결

### 서버가 실행되지 않을 때
1. Java 버전 확인
2. EULA 동의 확인
3. 포트 25565가 사용 가능한지 확인
4. 메모리 할당량 확인

### 연결이 안될 때
1. 서버 IP 주소 확인
2. 방화벽 설정 확인
3. 포트포워딩 설정 확인

## 참고 사항
- 서버 백업을 정기적으로 하는 것을 추천
- 플러그인 사용 시 호환성 확인 필요
- 성능 문제 발생 시 JVM 옵션 조정 검토