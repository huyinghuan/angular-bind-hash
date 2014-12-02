Angular-bind-hash
-------------
  Bind hash to element's value when page loaded and bind element's value to hash.
  This plugin for URL copy in angular application.

## How to install

### with bower.js

```
 bower install angular-bind-hash
```

### without bower.js

```
 download the file  https://raw.githubusercontent.com/huyinghuan/angular-bind-hash/master/angular-bind-hash.js
```

## Getting Start
1. include the angularjs and angular-bind-hash.js
example:

```html
  <script src="lib/angular.min.js"></script>
  <script src="module/angular-bind-hash.js"></script>
```

and then, in the application inject angular-bind-hash

```js
angular.module('app', ['honey.hashBind'])
```

finally, you can get the directive ```honey-bind-hash```

```html
<input type="text" name="username" honey-hash-bind/>
```

> Note:  the form element must have the attribute 'name'

this directive support ```checkbox``` ```input```(except password)
```radio``` ```select```

this directive will working in the html page loaded. at the moment, it will get 
the hash value and bind it to the element. when you need the element value bind to 
hash, you can broadcast a event ```honey:bindValueToHash```, for example:

```
$scope.$broadcast('honey:bindValueToHash')
```

after broadcast, all element that with ```honey-bind-hash``` will bind to hash.

## Demo

  the details see the directory ```sample```

## LINCENSE
  MIT

## History

0.0.1
  init plugin and test.