# kubernetes 网络

## kubernetes网络模型

扁平化网络

每个Pod都有有扁平化共享网络命名空间的IP

### 容器间通信

Pod创建容器时候，会产生