# Getting Started

### 1. Create folder local-repo. Its default ignored by .gitignore
Run this command for installing maven deps to local-repo, this step would be the first stage of CI pipeline
You may want to create settings.xml and provide option <b>-s settings.xml</b> to the end of below command
```
mvn clean install -DskipTests \
    -Dmaven.repo.local=local-repo
```

Run excutable jar file before building actual Docker image
```
java -jar target/test-docker-0.0.1-SNAPSHOT.jar
```

Build docker image with the following command
```
docker build -t test-docker .
```

Finally, run docker container from created image
```
docker run --rm \ 
    --name test-docker \
    -p 8080:8080 \
    -e PROFILE=dev \
    test-docker
```
We can alternate env variable PROFILE by prod or dev, the exposing port is the same as container servelet. By default, Tomcat serving port 8080