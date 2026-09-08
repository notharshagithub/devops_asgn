# Docker Multi-Stage Build Homework

**Name:** Harsha  
**Enrollment Number:** YOUR_ENROLLMENT_NUMBER

## Task 1: Run Multi-Stage Dockerfile

### Clone Repository

<!--
harsha@pop-os:~$ git clone <repository-url>
harsha@pop-os:~$ cd <repository-name>
-->

### Build Image

<!--
harsha@pop-os:~/repository-name$ docker build -t multi-stage-app .
[+] Building ... 
Successfully tagged multi-stage-app:latest
-->

### Run Container

<!--
harsha@pop-os:~/repository-name$ docker run -d -p 8080:8080 --name multi-stage-app multi-stage-app
<container-id>
-->

### Verify Application

<!--
harsha@pop-os:~/repository-name$ curl http://localhost:8080
Hello World from Docker multi-stage build
-->

Open in browser:

```text
http://localhost:8080
```

### Verify Container

<!--
harsha@pop-os:~/repository-name$ docker ps
CONTAINER ID   IMAGE             PORTS
<container-id> multi-stage-app   0.0.0.0:8080->8080/tcp
-->

---

## Task 2: Documentation

### Application Output

<!--
harsha@pop-os:~$ curl http://localhost:8080
Hello World from Docker multi-stage build
-->

### Docker Port

<!--
harsha@pop-os:~$ docker ps
CONTAINER ID   IMAGE             PORTS
<container-id> multi-stage-app   0.0.0.0:8080->8080/tcp
-->

---

## Task 3: Docker Application Deployment

### Node.js

<!--
harsha@pop-os:~$ cd nodejs-app
harsha@pop-os:~/nodejs-app$ docker build -t nodejs-app .
harsha@pop-os:~/nodejs-app$ docker run -d -p 3000:3000 --name nodejs-app nodejs-app
<container-id>
harsha@pop-os:~/nodejs-app$ curl http://localhost:3000
Hello World from Node.js
-->

### Python

<!--
harsha@pop-os:~$ cd python-app
harsha@pop-os:~/python-app$ docker build -t python-app .
harsha@pop-os:~/python-app$ docker run -d -p 5000:5000 --name python-app python-app
<container-id>
harsha@pop-os:~/python-app$ curl http://localhost:5000
Hello World from Python
-->

### Java

<!--
harsha@pop-os:~$ cd java-app
harsha@pop-os:~/java-app$ docker build -t java-app .
harsha@pop-os:~/java-app$ docker run -d -p 8081:8080 --name java-app java-app
<container-id>
harsha@pop-os:~/java-app$ curl http://localhost:8081
Hello World from Java
-->

### Verify All Containers

<!--
harsha@pop-os:~$ docker ps
CONTAINER ID   IMAGE             PORTS
<id>           multi-stage-app   0.0.0.0:8080->8080/tcp
<id>           nodejs-app        0.0.0.0:3000->3000/tcp
<id>           python-app        0.0.0.0:5000->5000/tcp
<id>           java-app          0.0.0.0:8081->8080/tcp
-->
