# Getting Started

### 1.Create folder local-repo. Its default ignored by .gitignore
Run this command for installing maven deps to local-repo, this step would be the first stage of CI pipeline
You may want to create settings.xml and provide option <b>-s settings.xml</b> to the end of below command
```
mvn clean install -DskipTests \
    -Dmaven.repo.local=local-repo
```