在本地启动 web-console，使用远程后端。

启动代理服务器绕开 cors

```bash
COOKIE= #从https://proxy.n.kube.tensorstack.net/echo/拿到cookie
cd $HOME/modgo/base
./bin/corsproxy --v=3 --server=https://proxy.n.kube.tensorstack.net --port=10080 --cookie="$COOKIE"
```

启动 web-console

```bash
export REACT_APP_T9K_CRD_GROUP=prod
export REACT_APP_T9K_PREFIX_ADDRESS='http://localhost:10080/t9k-system'
cd $HOME/modgo/web-console
yarn start
```

```bash
http://localhost:3000/?project=http://localhost:8080&minio=http://localhost:9000
```

```bash
https://proxy.n.kube.tensorstack.net/t9k-czx/minio-browser/?MinioProxyEndpoint=https://proxy.n.kube.tensorstack.net/t9k-czx/projects/czxs/proxy&MinioServerEndpoint=http://managed-minio-sample:9000
```

```bash
https://proxy.n.kube.tensorstack.net/browser/?project=https://proxy.n.kube.tensorstack.net/browserproxy&minio=http://minio:9000
```


```bash
https://proxy.n.kube.tensorstack.net/t9k-system/minio-browser/?project=project-wang&minio=demo
```

```bash
curl -v -H "Host: managed-nativeservice-test.mnist-sample.example.com" http://n04:31380/v1/models/test:predict -d $INPUT_PATH
```

https://proxy.n.kube.tensorstack.net/t9k-system/projects/project-wang/proxy/minio/download/temp/dumpbell-home.mp4?token=eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NjYxODEwMzYsInN1YiI6InRlbnNvcnN0YWNrIn0.D_w8EXhx4K4bRhGEHdFFuzS-mxA8idPBMDRm8Vuq_8ncaoioWiNG1fxvKqiz0PDWU9ojidm_PjSqLGz9YleedQ&t9k_proxy_endpoint=http://managed-minio-demo:9000&t9k_proxy_request_header_rewrite=Authorization%3A

https://proxy.n.kube.tensorstack.net/temp/dumpbell-home.mp4?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=tensorstack%2F20190819%2F%2Fs3%2Faws4_request&X-Amz-Date=20190819T021642Z&X-Amz-Expires=432000&X-Amz-SignedHeaders=host&X-Amz-Signature=cab29e45392b95d03e54c52e34d19ce5f2a9255a727e0b834bd0b9e91c48259f&t9k_proxy_endpoint=http://managed-minio-demo:9000&t9k_proxy_request_header_rewrite=Authorization%3A

https://proxy.n.kube.tensorstack.net/t9k-system/minio-browser/abc/1707.07012.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=tensorstack%2F20190819%2F%2Fs3%2Faws4_request&X-Amz-Date=20190819T021755Z&X-Amz-Expires=432000&X-Amz-SignedHeaders=host&X-Amz-Signature=3c0c5fa2246399bb4e4152893cc63f6231877f1a1bea66469f94400ca3fc5c0b&t9k_proxy_endpoint=http://managed-minio-demo:9000&t9k_proxy_request_header_rewrite=Authorization%3A