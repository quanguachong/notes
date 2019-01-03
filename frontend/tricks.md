# Tricks

## 1. 

Add arguments `{suffix:suffixIcon}` to **Input** according to `readonly`
```js
    <Input
        value={props.value === undefined ? '(none)' : props.value}
        onChange={onChange}
        style={style}
        {...(readonly ? undefined:{suffix:suffixIcon})}
      />
```