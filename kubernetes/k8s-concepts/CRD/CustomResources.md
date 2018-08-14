# Custom Resources(CR)

Custom resources are extensions of the Kubernetes API.

## synopsis

A custom resource is an extension of Kubernetes API

you can design your CR, and declare the CR to the cluster

### Custom controllers

A custom resource only simply let you store and retrieve structured data.

It is only when combined with a controller that they become a true declarative API. 

Note: the following is detail

A **declarative API** allows you to declare or specify the desired state of your resource and tries to match the actual state to this desired state. Here, the controller interprets the structured data as a record of the user’s desired state, and continually takes action to achieve and maintain this state.

A custom controller is a controller that users can deploy and update on a running cluster, independently of the cluster’s own lifecycle. Custom controllers can work with any kind of resource, but they are especially effective when combined with custom resources. 

### Adding custom resources

two ways to add custome resources:

* CRDs are simple and can be created without any programming.
* API Aggregation requires programming, but allows more control over API behaviors like how data is stored and conversion between API versions.

CustomResourcesDefinitions:

The CustomResourceDefinition API resource allows you to define custom resources. Defining a CRD object creates a new custom resource with a name and schema that you specify. The Kubernetes API serves and handles the storage of your custom resource.