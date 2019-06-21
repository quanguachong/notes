在本地启动 web-console，使用远程后端。

启动代理服务器绕开 cors

```bash
COOKIE= #从https://proxy.s.kube.tensorstack.net/echo/拿到cookie
cd $HOME/modgo/base
./bin/corsproxy --v=3 --server=https://proxy.s.kube.tensorstack.net --port=10080 --cookie="$COOKIE"
```

启动 web-console

```bash
export REACT_APP_T9K_CRD_GROUP=prod
export REACT_APP_T9K_PREFIX_ADDRESS='http://localhost:10080/t9k-system'
cd $HOME/mode/web-console
yarn start
```
