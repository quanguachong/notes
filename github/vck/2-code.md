# codes for vck controller

different from sample-controller, vck controller uses dynamic client

in ResourceEventHandler, vck controller directly deals with resources without workqueue

## dynamic client for vck controller

to use dynamic client in main.go

```go
// Since all the clients belong to the same gvk, only one dynamic client is needed in this case.
config.GroupVersion = &corev1.SchemeGroupVersion
dynClient, err := dynamic.NewClient(config)
```

then use

```go
dynClient.Resource(podAPIResource, *namespace)
```

Let's have a look at Client and Resource. Client.Resource is ResourceInterface which is an API interface to specific resource under a dynamic client.

```go
// Client is a Kubernetes client that allows you to access metadata
// and manipulate metadata of a Kubernetes API group, and implements Interface.
type Client struct {
	cl             *restclient.RESTClient
	parameterCodec runtime.ParameterCodec
}

// Resource returns an API interface to the specified resource for this client's
// group and version. If resource is not a namespaced resource, then namespace
// is ignored. The ResourceInterface inherits the parameter codec of c.
func (c *Client) Resource(resource *metav1.APIResource, namespace string) ResourceInterface {
	return &ResourceClient{
		cl:             c.cl,
		resource:       resource,
		ns:             namespace,
		parameterCodec: c.parameterCodec,
	}
}
```

## VolumeManagerHooks

Use VolumeManagerHooks implements controller.Hooks interface

when use different sourceTypes, VolumeManagerHoooks's Hooks interface(in Add, Update, and Delete) invoke the corresponding DataHandler while traversing VolumeManagerHooks.dataHandlers

```go
// VolumeManagerHooks implements controller.Hooks interface
type VolumeManagerHooks struct {
	crdClient    vckv1alpha1_volume_manager.VolumeManagerInterface
	dataHandlers []handlers.DataHandler
}
```

In controller.go, the Hooks interface solves cache.ResourceEventHandlerFuncs. In other words, VolumeManagers's Informer EventHandler is Hooks. However, Hooks is just an interface, the actual implement is VolumeManagerHooks in hooks.go

```go
// Hooks is the callback interface that defines controller behavior.
type Hooks interface {
	Add(obj interface{})
	Update(oldObj, newObj interface{})
	Delete(obj interface{})
}
```

## controller.go

in main.go use controller.New() and controller.Run

1. controller := controller.New(hooks, crdClient)

```go
// In main.go
// the concrete Handler to corresponding sourceType
dataHandlers := []handlers.DataHandler{
	handlers.NewS3Handler(k8sClientset, []resource.Client{nodeClient, pvClient, pvcClient, podClient, podClient}),
	handlers.NewNFSHandler(k8sClientset, []resource.Client{nodeClient, pvClient, pvcClient, podClient, podClient}),
	handlers.NewPachydermHandler(k8sClientset, []resource.Client{nodeClient, pvClient, pvcClient, pachydermPodClient}),
}

// Create VolumeManagerHooks
hooks := hooks.NewVolumeManagerHooks(crdClient.VckV1alpha1().VolumeManagers(*namespace), dataHandlers)

controller := controller.New(hooks, crdClient)
---------------------------------------------------------------------------------
// In controller.go
// New returns a new Controller.
func New(hooks Hooks, client vckv1alpha1_client.Interface) *Controller {
	return &Controller{
		Hooks:  hooks,
		Client: client,
	}
}
```

2. controller.Run(ctx, *namespace)

```go
// Run starts a resource controller
func (c *Controller) Run(ctx context.Context, namespace string) error {
	/**
	TODO: We spawn a goroutine with each onAdd hook. Investigate if that can be avoided by using something like:
	https://github.com/kubernetes/sample-controller/blob/master/controller.go#L169-L173.
	*/
	fmt.Print("Started watching for VolumeManager CR objects.\n")

	// Watch objects
	c.watch(ctx, namespace)

	<-ctx.Done()
	return ctx.Err()
}

func (c *Controller) watch(ctx context.Context, namespace string) {

	informer := vckv1alpha1_informer.NewFilteredSharedInformerFactory(c.Client, 0, namespace, nil)
	informer.Vck().V1alpha1().VolumeManagers().Informer().AddEventHandler(handlerFuncs(c.Hooks))

	go informer.Start(ctx.Done())

}
```

## Core codes

The core codes are in pkg/hooks/hooks.go, the struct VolumeManagerHooks. Must read the origin codes in vck.

The core idea is using text/template. 
1. According to different VolumeConfigs's SourceType, invoke corresponding handler. 

2. Each handler(of NFS, S3, Pachyderm ...) deal with the details. In fact, specify a struct 
and use text/template to fill the .tmpl file.

3. After that, use unstructed.Untructured{} to receive the data in .tmpl file.

4. Use dynamic client's Resource to create the resources of k8s(which specified in Handler.k8sResourceClients). And record in VolumeManager's status.

## To Understand

```go
k8s.io/apimachinery/pkg/apis/meta/v1/unstructured

// Unstructured allows objects that do not have Golang structs registered to be manipulated
// generically. This can be used to deal with the API objects from a plug-in. Unstructured
// objects still have functioning TypeMeta features-- kind, version, etc.
//
// WARNING: This object has accessors for the v1 standard metadata. You *MUST NOT* use this
// type if you are dealing with objects that are not in the server meta v1 schema.
//
// TODO: make the serialization part of this type distinct from the field accessors.
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
// +k8s:deepcopy-gen=true
type Unstructured struct {
	// Object is a JSON compatible map with string, float, int, bool, []interface{}, or
	// map[string]interface{}
	// children.
	Object map[string]interface{}
}
```