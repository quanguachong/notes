# cmd

## go

```bash
go env -w GO111MODULE=on
```

## awk

```bash
$ echo -e 'hello 1\n hi 2' > test.txt
$ awk '{print $2}' test.txt
1
2
```

## virtualenv 隔离环境

virtualenv:
source venv/bin/activate
deactivate

## goTest 命令行

go test show glog:
go test -v -run=" " -args -alsologtostderr

## 打开 vscode

vscode: code filename

## scp

```bash
scp cube:.kube/config n04-config
```

## others

vi ~/.bashrc 修改系统变量
mv <old-name> <new-name> 修改文件名

## base64

encode string "11111111"

```bash
# echo's flag -n means 不换行输出
$ echo -n 11111111 | base64
MTExMTExMTE=
```

decode string "MTExMTExMTE="

```bash
$ echo MTExMTExMTE= | base64 -D
11111111
```

## set proxy

export https_proxy=http://v01:3128
export http_proxy=http://v01:3128

export no_proxy=10.147.20.139

export https_proxy=http://c01:3128
export http_proxy=http://c01:3128

v01.corp.tensorstack.net(in browers)

minikube start --docker-env HTTP_PROXY=http://v01.corp.tensorstack.net:3128 \
 --docker-env HTTPS_PROXY=https://v01.corp.tensorstack.net:3128

## kill the specified thread

```bash
$ ps aux
$ ... # the info of threads include PID
$ kill -9 <PID>
```

## nfs

nfs.lab.tensorstack.net

user: wang
pwd: 111111

edit /etc/exports to add more entries, then restart nfs server

```console
$ sudo systemctl restart nfs-kernel-server
```

##

smoke test

```go
err = e.Env("http_proxy", "http://v01:3128").Env("https_proxy", "http://v01:3128").Run(ctx, "dep", "ensure")
```
