# event in k8s

// EventRecorder knows how to record events on behalf of an EventSource.
type **EventRecorder** interface{}

// EventBroadcaster knows how to receive events and send them to any EventSink, watcher, or log.
type **EventBroadcaster** interface{}

------------------------------------------------------------------------------------------------
use example

```go
eventBroadcaster := record.NewBroadcaster()
eventBroadcaster.StartLogging(glog.Infof)
eventBroadcaster.StartRecordingToSink(&typedcorev1.EventSinkImpl{Interface: kubeclientset.CoreV1().Events("")})
recorder := eventBroadcaster.NewRecorder(scheme.Scheme, corev1.EventSource{Component: controllerAgentName})

recorder.Event(notebook, corev1.EventTypeNormal, SuccessSynced, MessageResourceSynced)
```