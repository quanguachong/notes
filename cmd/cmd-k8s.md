# 有关上下文

```bash
kubectl config current-context                    当前上下文名字
kubectl config get-contexts                       获取上下文信息
kubectl config use-context <name>                 跳转到上下文<name>上
kubectl config set-context <name> --namespace=<ns>设置上下文的默认namespace

kubectl get pod --all-namespaces  获取所有namespace的pod
kubectl get pod --namespace=<namespace_name> 获取指定namespace下的pod

kubectl exec -ti <pod_name> -- bash              进入到pod容器里

k -n logging port-forward svc/efk-kibana 7788:443  暴露一个service

minikube start --bootstrapper=localkube
```

# 修改resource注释

```bash
kubectl patch storageclass <your-class-name> -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'

kubectl patch node black.corp.tensorstack.net -p '{"metadata": {"labels":{"nfs-node.tsz.io":"yes"}}}'
```



mnist image
tsz.io/mnist-test/mytfmodel:1.7