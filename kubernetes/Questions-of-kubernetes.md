# Questions

## 1 Declarative APIs and Imperative APIS

In a Declarative API, typically:

* Your API consists of a relatively small number of relatively small objects (resources).
* The objects define configuration of applications or infrastructure.
* The objects are updated relatively infrequently.
* Humans often need to read and write the objects.
* The main operations on the objects are CRUD-y (creating, reading, updating and deleting).
* Transactions across objects are not required: the API represents a desired state, not an exact state.

Imperative APIs are not declarative. Signs that your API might not be declarative include:

* The client says “do this”, and then gets a synchronous response back when it is done.
* The client says “do this”, and then gets an operation ID back, and has to check a separate Operation objects to determine completion of the request.
* You talk about Remote Procedure Calls (RPCs).
* Directly storing large amounts of data (e.g. > a few kB per object, or >1000s of objects).
* High bandwidth access (10s of requests per second sustained) needed.
* Store end-user data (such as images, PII, etc) or other large-scale data processed by applications.
* The natural operations on the objects are not CRUD-y.
* The API is not easily modeled as objects.
* You chose to represent pending operations with an operation ID or operation object.

**Thought**: imperative APIs means beyond kubernetes ?

## 2 Finalizer
