FROM openjdk:8-jdk-alpine as builder
WORKDIR /workspace/app
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src
# copy repo from CI pipeline
# COPY settings.xml .
COPY local-repo local-repo
RUN chmod +x mvnw
RUN ./mvnw clean package -DskipTests \
    -Dmaven.repo.local=local-repo
    # -s settings.xml
# watch excutable jar file content
RUN mkdir -p target/dependency && (cd target/dependency; java -Djarmode=layertools -jar ../*.jar extract)
RUN ls target/dependency

FROM openjdk:8-jdk-alpine as final
ARG DEPENDENCY=/workspace/app/target/dependency
COPY --from=builder ${DEPENDENCY}/dependencies ./
COPY --from=builder ${DEPENDENCY}/spring-boot-loader ./
COPY --from=builder ${DEPENDENCY}/application ./
ENV PROFILE=dev
ENTRYPOINT ["sh", "-c","java org.springframework.boot.loader.JarLauncher --Dspring.profiles.active=${PROFILE} ", "--jasypt.encryptor.password=supersecretz", "-server", "-Xmx1G -Xms1G -Ddebug"]
# exposing port with the same as serverlet
EXPOSE 8080