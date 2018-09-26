# tf-operator controls the operator according to states

## Nice action

1. leaderElection for start a operator

2. defaults.go for code-generator, scheme.Scheme.Default()

3. workqueue NewMaxOfRateLimiter. so many differences to figure out

4. tf-operator uses SyncPods() and SyneServices() to create pods and services in TrainingJob.Reconcile()

5. tf-operator set some states for Tfjob and replicas

**TFJobPhase**, **State**, **TFReplicaType**

(1) TFJob.Status.Phase is **TFJobPhase**, represents the TFJob running phase
```go
// TFJobPhase is a enum to store the phase of tf job
type TFJobPhase string

const (
	TFJobPhaseNone     TFJobPhase = ""
	TFJobPhaseCreating TFJobPhase = "Creating"
	TFJobPhaseRunning  TFJobPhase = "Running"
	TFJobPhaseCleanUp  TFJobPhase = "CleanUp"
	TFJobPhaseFailed   TFJobPhase = "Failed"
	TFJobPhaseDone     TFJobPhase = "Done"
)
```

(2) TFJob.Status.State is **State**, represents the state of the TFJob
```go
// State is a enum to store the state of tf job
type State string

const (
	StateUnknown   State = "Unknown"
	StateRunning   State = "Running"
	StateSucceeded State = "Succeeded"
	StateFailed    State = "Failed"
)
```

(3) TFJob.Status.ReplicaStatuses is []*TFReplicaStatus, specifies the status of each TF replica
```go
// TFReplicaType determines how a set of TF processes are handled.
type TFReplicaType string

const (
	MASTER TFReplicaType = "MASTER"
	PS     TFReplicaType = "PS"
	WORKER TFReplicaType = "WORKER"
)
// TFReplicaStatus  is a structure for storing the status of tf replica
type TFReplicaStatus struct {
	TFReplicaType `json:"tf_replica_type"`

	// State is the overall state of the replica
	State ReplicaState `json:"state"`

	// ReplicasStates provides the number of replicas in each status.
	ReplicasStates map[ReplicaState]int
}
```
```go
// ReplicaState is a enum to store the status of replica
type ReplicaState string

const (
	ReplicaStateUnknown   ReplicaState = "Unknown"
	ReplicaStateRunning   ReplicaState = "Running"
	ReplicaStateFailed    ReplicaState = "Failed"
	ReplicaStateSucceeded ReplicaState = "Succeeded"
)
```

## container's states

This is where we can figure out the replicas's statuses

Pods.Status.ContainerStatuses []containerStatus

ContainerStatus.State is following

1. State.Terminated.ExitCode = 0 means the container exit successfully

2. State.Terminated.Reason = "OOMKilled" , (don't know the Reason's values and meanings)

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

