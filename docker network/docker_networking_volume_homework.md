# Docker Networking & Volume Homework

## Task 1: Docker Container Networking

### Create Networks

```bash
harsha@pop-os:~$ docker network create frontend-net
a1b2c3d4

harsha@pop-os:~$ docker network create backend-db-net
e5f6g7h8

harsha@pop-os:~$ docker network create extra-net
i9j0k1l2
```

### Create Containers

```bash
harsha@pop-os:~$ docker run -d --name frontend --network frontend-net nginx
harsha@pop-os:~$ docker run -d --name backend --network frontend-net alpine sh -c "while true; do sleep 3600; done"
harsha@pop-os:~$ docker run -d --name database --network backend-db-net -e MYSQL_ROOT_PASSWORD=root mysql:8
```

### Add Backend to Second Network

```bash
harsha@pop-os:~$ docker network connect backend-db-net backend
```

### Connect Frontend to Third Network

```bash
harsha@pop-os:~$ docker network connect extra-net frontend
```

### Check Networks

```bash
harsha@pop-os:~$ docker network ls
NETWORK ID     NAME             DRIVER
a1b2c3d4       frontend-net     bridge
e5f6g7h8       backend-db-net   bridge
i9j0k1l2       extra-net        bridge
```

### Check Connectivity

```bash
harsha@pop-os:~$ docker exec backend ping -c 2 frontend
PING frontend (...) 56 data bytes
64 bytes from ...: seq=0 ttl=64 time=0.0xx ms
64 bytes from ...: seq=1 ttl=64 time=0.0xx ms
--- frontend ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
```

```bash
harsha@pop-os:~$ docker exec backend ping -c 2 database
PING database (...) 56 data bytes
64 bytes from ...: seq=0 ttl=64 time=0.0xx ms
64 bytes from ...: seq=1 ttl=64 time=0.0xx ms
--- database ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
```

---

## Task 2: Host Network

### Pull Apache Image

```bash
harsha@pop-os:~$ docker pull httpd:2.4
2.4: Pulling from library/httpd
Status: Downloaded newer image for httpd:2.4
```

### Run Using Host Network

```bash
harsha@pop-os:~$ docker run -d --name apache-host --network host httpd:2.4
aabbccddeeff
```

### Verify

```bash
harsha@pop-os:~$ curl http://localhost:80
<html><body><h1>It works!</h1></body></html>
```

Open `http://localhost:80` in a browser.

---

## Task 3: Bind Mount

### Create Folder and HTML File

```bash
harsha@pop-os:~$ mkdir nginx-data
harsha@pop-os:~$ echo "Hello students" > nginx-data/index.html
```

### Run Nginx With Bind Mount

```bash
harsha@pop-os:~$ docker run -d --name nginx-volume -p 8080:80 -v ~/nginx-data:/usr/share/nginx/html:ro nginx
aabbccddeeff
```

### Verify Content

```bash
harsha@pop-os:~$ curl http://localhost:8080
Hello students
```

### Modify the File

```bash
harsha@pop-os:~$ echo "Hello students, Docker!" > nginx-data/index.html
```

### Verify Without Restarting

```bash
harsha@pop-os:~$ curl http://localhost:8080
Hello students, Docker!
```

---

## Task 4: Overlay Network

Overlay networks allow Docker containers on different Docker hosts to communicate as if they are on the same network. They are mainly used with Docker Swarm for multi-host container communication.

### Create a Swarm

```bash
harsha@pop-os:~$ docker swarm init
Swarm initialized: current node (...) is now a manager.
```

### Create Overlay Network

```bash
harsha@pop-os:~$ docker network create -d overlay overlay-net
xxxxxxxxxxxxxxxx
```

### Check Network

```bash
harsha@pop-os:~$ docker network ls
NETWORK ID     NAME          DRIVER    SCOPE
xxxxxxxx       overlay-net   overlay   swarm
```

## Verify Running Containers

```bash
harsha@pop-os:~$ docker ps
CONTAINER ID   IMAGE       PORTS
...            nginx       0.0.0.0:8080->80/tcp
...            httpd       ...
...            mysql:8     ...
...            alpine      ...
```
