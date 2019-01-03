# javascript

## 1. Event

The Event interface represents an event which takes place in the DOM;

Many DOM elements can be set up to accept (or "listen" for) these events, and execute code in response to process (or "handle") them.

[MDN doc](https://developer.mozilla.org/en-US/docs/Web/API/Event)

### StorageEvent

A StorageEvent is sent to a window when a storage area it has access to is changed within the context of another document.

[MDN doc](https://developer.mozilla.org/en-US/docs/Web/API/StorageEvent)

## 2. window

### EventListener

1. window.addEventListener()

    Add event listeners on the window object.

    **Example:**

    The `storage` event is fired when a storage area(localStorage or sessionStorage) has been modified.
    ```js
    window.addEventListener('storage', handler, false)
    ```

## 3. Storage

The Storage interface of the Web Storage API provides access to a particular domain's session or local storage. It allows, for example, the addition, modification, or deletion of stored data items.

### LocalStorage

The read-only localStorage property allows you to access a `Storage` object for the Document's origin; the stored data is saved across browser sessions. localStorage is similar to sessionStorage, except that while data stored in localStorage has no expiration time, data stored in sessionStorage gets cleared when the page session ends — that is, when the page is closed.

`Storage` interface: [MDN doc](https://developer.mozilla.org/en-US/docs/Web/API/Storage)

## 4. EventEmitter

1. addListener and removeListener

    **Definition**
    ```js
    addListener(eventName: string | symbol, listener: (...args: any[]) => void): this;
    ```
    Adds the listener function to the end of the listeners array for the event named `eventName`. No checks are made to see if the listener has already been added. Multiple calls passing the same combination of eventName and listener will result in the listener being added, and called, multiple times.

    **Example:**

    `addListener` adds an event listener for the specified event.
    ```js
    const authInfoEmitter = new EventEmitter()
    authInfoEmitter.addListener("auth_info", (authInfo: AuthInfo) => void)
    ```

    Then, `removeListener`
    ```js
    authInfoEmitter.removeListener("auth_info", (authInfo: AuthInfo) => void))
    ```

2. emit

    **Definition**
    ```js
    emit(eventName: string | symbol, ...args: any[]): boolean;
    ```
    Synchronously calls each of the listeners registered for the event named `eventName`, in the order they were registered, **passing the supplied arguments to each**.

    Returns true if the event had listeners, false otherwise.
    
    **Example:**
    ```js
    authInfoEmitter.emit("auth_info",loadAuthInfo())
    ```

3. listenerCount

    **Definition**
    ```js
    listenerCount(eventName: string): integer
    ```
    Returns the number of listeners listening to the event named eventName

## 5. Object

### Object.values()

The Object.values() method returns an array of a given object's own enumerable property values.

**Example:**
```js
const object1 = {
  a: 'somestring',
  b: 42,
  c: false
};

console.log(Object.values(object1));
// expected output: Array ["somestring", 42, false]
```

## 6. logic

### for loop

1. **for** takes three expressions: a variable declaration, an expression to be evaluated before each iteration, and an expression to be evaluated at the end of each iteration.

**Example:**
```js
const array = ['a', 'b', 'c', 'd'];

for (let i = 0; i < array.length; i++) {
  console.log(array[i]);
}

// Result: a, b, c, d
```

2. **for ..in**

**for..in** is a method for iterating over "enumerable" properties of an object. It therefore applies to all objects (not only Object()s) that have these properties.

Note: An enumerable property is defined as a property of an object that has an **Enumerable** value of true.
* Objects
    ```js
    const obj = {
	    1: 1,
	    2: 2,
        c: 3,
        d: 4
    }

    for (const key in obj) {
    	console.log( key )
    }
    // Result: "1", "2", "c", "d"
    ```

* Arrays
    ```js
    const array = ['a', 'b', 'c', 'd'];

    for (const index in array) {
	    console.log(index)
    }
    // Result: "0", "1", "2", "3"
    ```

* Strings
    ```js
    const string = 'abc';

    for (const index in string) {
        console.log(index)
    }
    // Result: "0", "1", "2"
    ```

3. **for ..of**

**for ..of** is a method, introduced in ES2015, for iterating over "iterable collections". These are objects that have a [Symbol.iterator] property. It is a wrapper around the [Symbol.iterator] to create loops.

Note: The [Symbol.iterator] property allows us to manually iterate over the collection by calling the `[Symbol.iterator]().next()` method to retrieve the next item in the collection.
```js
const array = ['a','b','c', 'd'];
const iterator = array[Symbol.iterator]();
console.log( iterator.next().value )
console.log( iterator.next() )
console.log( iterator.next().value )
console.log( iterator.next().value )
// Result: a, Object { value: "b", done: false }, c, d
```

* Objects

    not work, because Objects are not "iterable".

* Arrays/Strings
    ```js
    const array = ['a', 'b', 'c', 'd'];
    for (const item of array) {
    	console.log(item)
    }
    // Result: a, b, c, d

    const string = 'Ire Aderinokun';
    for (const character of string) {
    	console.log(character)
    }
    // Result: I, r, e, , A, d, e, r, i, n, o, k, u, n
    ```

* NodeLists

    Finally, another really useful case for **for..of** is in iterating of NodeLists. When we query the document for a group of elements, what we get returned is a **NodeList**, not an Array. This means that we can't iterate over the list using Array methods like **forEach**.

    To solve this, we can either convert it to an Array using **Array.from()**, or use the **for..of** loop, which is applicable to more than just Arrays.

    ```js
    const elements = document.querySelectorAll('.foo');

    for (const element of elements) {
        element.addEventListener('click', doSomething);
    }
    ```