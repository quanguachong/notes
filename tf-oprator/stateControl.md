# tf-operator controls the operator according to states

## container's states

Pods.Status.ContainerStatuses

ContainerStatus.State is following

State.Terminated.ExitCode = 0 means the container exit successfully

```go
// ContainerState holds a possible state of container.
// Only one of its members may be specified.
// If none of them is specified, the default one is ContainerStateWaiting.
type ContainerState struct {
	// Details about a waiting container
	// +optional
	Waiting *ContainerStateWaiting `json:"waiting,omitempty" protobuf:"bytes,1,opt,name=waiting"`
	// Details about a running container
	// +optional
	Running *ContainerStateRunning `json:"running,omitempty" protobuf:"bytes,2,opt,name=running"`
	// Details about a terminated container
	// +optional
	Terminated *ContainerStateTerminated `json:"terminated,omitempty" protobuf:"bytes,3,opt,name=terminated"`
}

// ContainerStateTerminated is a terminated state of a container.
type ContainerStateTerminated struct {
	// Exit status from the last termination of the container
	ExitCode int32 `json:"exitCode" protobuf:"varint,1,opt,name=exitCode"`
	// Signal from the last termination of the container
	// +optional
	Signal int32 `json:"signal,omitempty" protobuf:"varint,2,opt,name=signal"`
	// (brief) reason from the last termination of the container
	// +optional
	Reason string `json:"reason,omitempty" protobuf:"bytes,3,opt,name=reason"`
	// Message regarding the last termination of the container
	// +optional
	Message string `json:"message,omitempty" protobuf:"bytes,4,opt,name=message"`
	// Time at which previous execution of the container started
	// +optional
	StartedAt metav1.Time `json:"startedAt,omitempty" protobuf:"bytes,5,opt,name=startedAt"`
	// Time at which the container last terminated
	// +optional
	FinishedAt metav1.Time `json:"finishedAt,omitempty" protobuf:"bytes,6,opt,name=finishedAt"`
	// Container's ID in the format 'docker://<container_id>'
	// +optional
	ContainerID string `json:"containerID,omitempty" protobuf:"bytes,7,opt,name=containerID"`
}
```

