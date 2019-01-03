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

# 获取serviceaccount admin-user 对应部分的值
k get serviceaccount admin-user --template "{{range .secrets}}{{.name}}{{'\n'}}{{end}}"
```

# 修改resource注释

```bash
kubectl patch storageclass <your-class-name> -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'

kubectl patch node black.corp.tensorstack.net -p '{"metadata": {"labels":{"nfs-node.tsz.io":"yes"}}}'

kubectl patch node black.corp.tensorstack.net -p '{"spec":{"unschedulable":"true"}}'
```

# 用kubectl获取resource部分内容

```bash
SECRET=$(kubectl get serviceaccount admin-user --namespace "kube-system" --template '{{range .secrets}}{{.name}}{{"\n"}}{{end}}')

TOKEN=$(kubectl get secret "$SECRET" --namespace "kube-system" --template '{{.data.token}}' | base64 --decode)
```


# Add curl pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: curl
  namespace: mac
spec:
  containers:
  - name: test
    image: radial/busyboxplus:curl
    tty: true
```

```bash
$ 
```
