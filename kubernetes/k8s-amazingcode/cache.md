# import "k8s.io/client-go/tools/cache"

## 1. cache.MetaNamespaceKeyFunc(obj interface{}) (string,error)

MetaNamespaceKeyFunc is a convenient default KeyFunc which knows how to make keys for API objects which implement meta.Interface.

The key uses the format \<namespace>\/\<name> unless \<namespace> is empty, then it's just \<name>.

## 2. cache.SplitMetaNamespaceKey(key string) (namespace, name string, err error)

SplitMetaNamespaceKey returns the namespace and name that MetaNamespaceKeyFunc encoded into key.