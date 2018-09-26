# cmd

## virtualenv隔离环境

virtualenv:
   source venv/bin/activate
   deactivate

## goTest命令行

go test show glog:
   go test -v -run=" " -args -alsologtostderr

## 打开vscode

vscode:  code filename

## others

vi ~/.bashrc 修改系统变量
mv <old-name> <new-name> 修改文件名

## set proxy

export https_proxy=http://v01:3128
export http_proxy=http://v01:3128

v01.corp.tensorstack.net(in browers)

minikube start --docker-env HTTP_PROXY=http://v01.corp.tensorstack.net:3128 \
                 --docker-env HTTPS_PROXY=https://v01.corp.tensorstack.net:3128