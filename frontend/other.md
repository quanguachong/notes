# other contents

## axios

Promise based HTTP client for the bowser and node.js

A Usage example
```js
const response = await axios.post(getAuthUrl(), undefined, {
    headers: {Authorization: `Bearer ${token}`},
  })
console.log(response.data);  // content of body
console.log(response.status);
console.log(response.statusText);
console.log(response.headers);
console.log(response.config);
```