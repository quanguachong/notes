# event in k8s

// EventRecorder knows how to record events on behalf of an EventSource.
type **EventRecorder** interface{}

// EventBroadcaster knows how to receive events and send them to any EventSink, watcher, or log.
type **EventBroadcaster** interface{}