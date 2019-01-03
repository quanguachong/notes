# Features in React

## Hooks in React

Hooks are functions that let you "hook into" React state and lifecycle features from function components. Hooks don't work inside classes, they let you use React without classes.

**一、 built-in hooks**

1. Using the State Hook

    **useState**
    ```javascript
    const [state, setState] = useState(initialState);
    ```
    Returns a stateful value `state`, and a function `setState` to update it.

    `state` is the same as the value passed as the first argument `initialState` during the initial render.

    Example
    ```js
    const [count, setCount] = useState(0)
    ```
    `count`'s initial value is `0`, 

2. Using the Effect Hook

    **useEffect**
    ```js
    useEffect(didUpdate);
    ```
    The function `didUpdate` passed to useEffect will run after the render is committed to the screen.

    * Cleaning up an effect
    Often, effects create resources that need to be cleaned up before the component leaves the screen, such as a subscription or timer ID. To do this, the function passed to **useEffect** may return a clean-up function.

    example:
    ```js
    useEffect(() => {
      const subscription = props.source.subscribe();
      return () => {
        /* Clean up the subscription */
        subscription.unsubscribe();
      };
    });
    ```

    * Conditionally firing an effect

    By default, effects run after every completed render. But you can choose to fire it only when certain values have changed.

    example: effects run only after `[props.source]` has changed
    ```js
    useEffect(
      () => {
        const subscription = props.source.subscribe();
        return () => {
          subscription.unsubscribe();
        };
      },
      [props.source],
    );
    ```

**二、 Additional Hooks**

1. useMemo

    Allow you to memoize expensive functions so that you can avoid calling them on every render.
    ```js
    const memoizedValue = useMemo(() => computeExpensiveValue(a, b), [a, b]);
    ```
    useMemo returns a **memoized value**. useMemo only recompute the **memoized value** when one of the inputs `[a,b]` has changed. This optimization helps to avoid expensive calculations on every render.