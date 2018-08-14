# Extend the Kubernetes API with CustomResourceDefinitions

## Create a CustomResourceDefinition

When creating a new CRD, APIServer creates a new RESTful resource path for each version you specify.

A example
```yaml
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  # name must match the spec fields below, and be in the form: <plural>.<group>
  name: crontabs.stable.example.com
spec:
  # group name to use for REST API: /apis/<group>/<version>
  group: stable.example.com
  # list of versions supported by this CustomResourceDefinition
  versions:
    - name: v1
      # Each version can be enabled/disabled by Served flag.
      served: true
      # One and only one version must be marked as the storage version.
      storage: true
  # either Namespaced or Cluster
  scope: Namespaced
  names:
    # plural name to be used in the URL: /apis/<group>/<version>/<plural>
    plural: crontabs
    # singular name to be used as an alias on the CLI and for display
    singular: crontab
    # kind is normally the CamelCased singular type. Your resource manifests use this.
    kind: CronTab
    # shortNames allow shorter string to match your resource on the CLI
    shortNames:
    - ct
```

create it
```bash
$ kubectl create -f resourcedefinition.yaml
```

After creation, a new namespaced RESTful API endpoint:
```bash
/apis/stable.example.com/v1/namespaces/*/crontabs/...
```

The endpoint URL can be used to create and manage custom objects **CronTab**

## Create custom objects

You can create custom objects after the CRD object has been created.

```yaml
apiVersion: "stable.example.com/v1"
kind: CronTab
metadata:
  name: my-new-cron-object
spec:
  cronSpec: "* * * * */5"
  image: my-awesome-cron-image
```

## [Advanced topics](https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/#create-a-customresourcedefinition)

### Finalizers

### Validation

Validation of custom objects is possible via [OpenAPI v3 schema](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#schemaObject). Additionally, the following restrictions are applied to the schema:


* The fields **default**, **nullable**, **discriminator**, **readOnly**, **writeOnly**, **xml**, **deprecated** and **$ref** cannot be set.
* The field **uniqueItems** cannot be set to true.
* The field **additionalProperties** cannot be set to false.

can disable the feature using the **CustomResourceValidation** feature gate on the kube-apiserver:
```bash
--feature-gates=CustomResourceValidation=false
```

Usage example:
```yaml
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: crontabs.stable.example.com
spec:
  group: stable.example.com
  versions:
    - name: v1
      served: true
      storage: true
  version: v1
  scope: Namespaced
  names:
    plural: crontabs
    singular: crontab
    kind: CronTab
    shortNames:
    - ct
  validation:
   # openAPIV3Schema is the schema for validating custom objects.
    openAPIV3Schema:
      properties:
        spec:
          properties:
            cronSpec:
              type: string
              pattern: '^(\d+|\*)(/\d+)?(\s+(\d+|\*)(/\d+)?){4}$'
            replicas:
              type: integer
              minimum: 1
              maximum: 10
```

```bash
$ kubectl create -f resourcedefinition.yaml
```

Then you create a resource as bellow:
```yaml
apiVersion: "stable.example.com/v1"
kind: CronTab
metadata:
  name: my-new-cron-object
spec:
  cronSpec: "* * * *"
  image: my-awesome-cron-image
  replicas: 15
```
you will get error and can't create the CronTab/my-new-cron-object

### Additional printer columns

### Subresources

### Categories