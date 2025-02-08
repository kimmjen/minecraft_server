FROM eclipse-temurin:21-jre-jammy

WORKDIR /minecraft

# 환경 변수 설정
ENV MEMORY_SIZE=4G

# 필요한 도구 설치 및 정리
RUN apt-get update && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 로컬의 server.jar 파일 복사
COPY server.jar /minecraft/server.jar

# eula.txt 생성
RUN echo "eula=true" > eula.txt

# 비root 사용자 생성 및 권한 설정
RUN useradd -r -U -m minecraft && \
    chown -R minecraft:minecraft /minecraft

USER minecraft

# 서버 포트 노출
EXPOSE 25565

# 볼륨 설정
VOLUME ["/minecraft/world", "/minecraft/logs", "/minecraft/config"]

# 서버 실행 (JVM 튜닝 옵션 추가)
CMD ["sh", "-c", "java -Xmx${MEMORY_SIZE} -Xms${MEMORY_SIZE} \
    -XX:+UseG1GC \
    -XX:+ParallelRefProcEnabled \
    -XX:MaxGCPauseMillis=200 \
    -XX:+UnlockExperimentalVMOptions \
    -XX:+DisableExplicitGC \
    -XX:+AlwaysPreTouch \
    -XX:G1NewSizePercent=30 \
    -XX:G1MaxNewSizePercent=40 \
    -XX:G1HeapRegionSize=8M \
    -XX:G1ReservePercent=20 \
    -XX:G1HeapWastePercent=5 \
    -XX:G1MixedGCCountTarget=4 \
    -XX:InitiatingHeapOccupancyPercent=15 \
    -XX:G1MixedGCLiveThresholdPercent=90 \
    -XX:G1RSetUpdatingPauseTimePercent=5 \
    -XX:SurvivorRatio=32 \
    -XX:+PerfDisableSharedMem \
    -XX:MaxTenuringThreshold=1 \
    -jar server.jar nogui"]