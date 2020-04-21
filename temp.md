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

docker run -p 8501:8501 \
 --mount type=bind,source=/Users/czx/models/single/model/,target=/models/my_model \
 -e MODEL_NAME=my_model -t tensorflow/serving

```bash
$ export DATA='{}' # value in data.json
$ curl -H "Content-Type: application/json" http://managed-nativeservice-f9e6e6ef197c2b25.test.n.ksvc.tensorstack.net/v1/models/test:predict -d "$DATA"

$ hey -m POST -d "$DATA"  http://managed-nativeservice-f9e6e6ef197c2b25.test.n.ksvc.tensorstack.net/v1/models/test:predict

$ hey -m POST -D /Users/czx/Downloads/data.json  http://managed-nativeservice-f9e6e6ef197c2b25.test.n.ksvc.tensorstack.net/v1/models/test:predict

$ hey http://managed-nativeservice-f9e6e6ef197c2b25.test.n.ksvc.tensorstack.net/v1/models/test
```
