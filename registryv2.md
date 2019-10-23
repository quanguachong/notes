# run registry v2 locally

启动
```bash
$ cat > config.yml

$ docker run -d \
    -p 5000:5000 \
    --restart=always \
    --name registry \
    -v `pwd`/config.yml:/etc/docker/registry/config.yml \
    registry:2
```

上传文件
```bash
$ echo "This is an interesting file." > hello.txt

$ oras push localhost:5000/hello:latest hello.txt
```

下载文件
```bash
$ oras pull localhost:5000/hello:latest
```