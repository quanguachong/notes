# 有关上下文

```bash
kubectl config get-contexts                       获取上下文信息
kubectl config use-context <name>                 跳转到上下文<name>上
kubectl config set-context <name> --namespace=<ns>设置上下文的默认namespace为ns

kubectl get pod --all-namespaces  获取所有namespace的pod
kubectl get pod --namespace=<namespace_name> 获取指定namespace下的pod
```