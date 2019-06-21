新增的两个集群：

centos : s03.lab.tensorstack.net

ubuntu : sb02.lab.tensorstack.net

config 路径 /etc/kubernetes/

serviceName.namespaceName.svc.cluster.local

docker run \
 -v /Users/czx/tmp/to/root:/srv \
 -v /Users/czx/tmp/filebrowser.db:/database.db \
 -v /Users/czx/tmp/.filebrowser.json:/.filebrowser.json \
 -p 80:80 \
 filebrowser/filebrowser

    docker run \
    -p 80:80 \
    filebrowser/filebrowser
