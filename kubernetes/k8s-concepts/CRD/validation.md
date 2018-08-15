# validation for CRD

Validation of custom objects is possible via [OpenAPI v3 schema](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#schemaObject). Additionally, the 

can disable the feature using the **CustomResourceValidation** feature gate on the kube-apiserver:

```bash
--feature-gates=CustomResourceValidation=false
```

## Usage example

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
...
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

## [Schema Object](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#schema-object)

following restrictions are applied to the schema:

* The fields **default**, **nullable**, **discriminator**, **readOnly**, **writeOnly**, **xml**, **deprecated** and **$ref** cannot be set.
* The field **uniqueItems** cannot be set to true.
* The field **additionalProperties** cannot be set to false.

### Properties

The following properties are taken directly from the JSON Schema definition and follow the same specifications:

* title
* multipleOf
* maximum
* exclusiveMaximum
* minimum
* exclusiveMinimum
* maxLength
* minLength
* pattern (This string SHOULD be a valid regular expression, according to the ECMA 262 regular expression dialect)
* maxItems
* minItems
* uniqueItems
* maxProperties
* minProperties
* required
* enum

The following properties are taken from the JSON Schema definition but their definitions were adjusted to the OpenAPI Specification.

* type - Value MUST be a string. Multiple types via an array are not supported.

* allOf - Inline or referenced schema MUST be of a Schema Object and not a standard JSON Schema.
* oneOf - Inline or referenced schema MUST be of a Schema Object and not a standard JSON Schema.
* anyOf - Inline or referenced schema MUST be of a Schema Object and not a standard JSON Schema.
* not - Inline or referenced schema MUST be of a Schema Object and not a standard JSON Schema.
* items - Value MUST be an object and not an array. Inline or referenced schema MUST be of a Schema Object and not a standard JSON Schema. items MUST be present if the type is array.
* **properties** - Property definitions MUST be a Schema Object and not a standard JSON Schema (inline or referenced).
* additionalProperties - Value can be boolean or object. Inline or referenced schema MUST be of a Schema Object and not a standard JSON Schema.
* description - CommonMark syntax MAY be used for rich text representation.
* format - See Data Type Formats for further details. While relying on JSON Schema's defined formats, the OAS offers a few additional predefined formats.
* default - The default value represents what would be assumed by the consumer of the input as the value of the schema if one is not provided. Unlike JSON Schema, the value MUST conform to the defined type for the Schema Object defined at the same level. For example, if type is string, then default can be "foo" but cannot be 1.

### Fixed Fields

|Field Name|Type|Description|
|----------|----|-----------|
|example|Any|A free-form property to include an example of an instance for this schema.(To represent examples that cannot be naturally represented in JSON or YAML, a string value can be used to contain the example with escaping where necessary.)|
|externalDocs|External Documentation Object|Additional external documentation for this schema.|

### keyword

* properties

The properties (key-value pairs) on an object are defined using the properties keyword. The value of properties is an object, where each key is the name of a property and each value is a JSON schema used to validate that property.

e.g. name's type is string, and age's is int whose value in [1-10]

```yaml
type: object
properties:
  name:
    type: string
  age:
    type: int
    minimum: 1
    maximum: 10
```

* required

one can provide a list of required properties using the keyword *required*

e.g. name must be set

```yaml
type: object
properties:
  name:
    type: string
  age:
    type: int
    minimum: 1
    maximum: 10
required:
- name
```

* more...

### Schema Object Examples

the following examples are not for kubernetes CRD validations

```yaml

components:
  schemas:
    ErrorModel:
      type: object
      required:
      - message
      - code
      properties:
        message:
          type: string
        code:
          type: integer
          minimum: 100
          maximum: 600
    ExtendedErrorModel:
      allOf:
      - $ref: '#/components/schemas/ErrorModel'
      - type: object
        required:
        - rootCause
        properties:
          rootCause:
            type: string

---

components:
  schemas:
    Pet:
      type: object
      discriminator:
        propertyName: petType
      properties:
        name:
          type: string
        petType:
          type: string
      required:
      - name
      - petType
    Cat:  ## "Cat" will be used as the discriminator value
      description: A representation of a cat
      allOf:
      - $ref: '#/components/schemas/Pet'
      - type: object
        properties:
          huntingSkill:
            type: string
            description: The measured skill for hunting
            enum:
            - clueless
            - lazy
            - adventurous
            - aggressive
        required:
        - huntingSkill
    Dog:  ## "Dog" will be used as the discriminator value
      description: A representation of a dog
      allOf:
      - $ref: '#/components/schemas/Pet'
      - type: object
        properties:
          packSize:
            type: integer
            format: int32
            description: the size of the pack the dog is from
            default: 0
            minimum: 0
        required:
        - packSize
```