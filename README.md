Angular-bind-hash
-------------
  Bind hash to element's value when page loaded and bind element's value to hash.
  This plugin for URL copy in angular application.


## Homepage

https://huyinghuan.github.io/angular-bind-hash/

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

if element is ```select``` and option bind data, the children options also need
set ```honey-hash-bind```:

```
<select name="birth"  honey-hash-bind>
  <option ng-repeat='item in list' value="{{item}}" honey-hash-bind>{{item}}</option>
</select>
```

and if option don't bind data,  ```honey-hash-bind``` don't need:

```
<select name="sex" honey-hash-bind>
  <option value='man'>man</option>
  <option value='male'>male</option>
</select>
```


> Note:  the form element must have the attribute 'name'

this directive support ```checkbox``` ```input```(type is text, email, and so on)
```radio``` ```select```

this directive will working in the html page loaded. at the moment, it will get 
the hash value and bind it to the element. when you need the element value bind to 
hash, you can broadcast a event ```honey:bindValueToHash```, for example:

```
$scope.$broadcast('honey:bindValueToHash')
```

after broadcast, all element that with ```honey-bind-hash``` will bind to hash.

Of course, you can also broadcast a ```honey:bindHashToElement``` event,
make this directive working.

### Trigger bind value by event

#### Default events

By the default, this directive bind a event on element, it will work when
elements be clicked or changed or other action. the follow content is the list of event
description:

for ```input``` (like type is ```text```, ```email``` or other) element, the event is
```Enter``` key be clicked.

```coffeescript
'TEXT': [
        'keyup'
        (e, cb)->
          if e.keyCode is 13
            e.preventDefault()
            cb and cb()
      ]
```

> the function cb is the action that bind value to hash

for ```select``` element, the event is ```change```.
for ```checkbox``` element, the event is ```click```.
for ```radio``` element, the event is ```click```.

#### Forbid default event or Rewrite default event.

if you don't want to bind value every time when event trigger or rewrite event,
you can set it by ``` bindHashProvider.setEventsMap```. for example:

```javascript
angular.module('app', ['honey.hashBind'])
  .config(['hashBindProvider', function(provider){
    eventMap = {
      'SELECT': false //Forbid select change event event.
      'TEXT': [  //rewrite Enter key press events. working on element blur focus
        'blur',
        function(e, cb){
          cb and cb()
        }
       'CHECKBOX': ...
       'RADIO': ...
      ]
    }
    provider.setEventsMap(eventMap)
  }])
```

Maybe  you can omit the event function:

```
angular.module('app', ['honey.hashBind'])
  .config(['hashBindProvider', function(provider){
    eventMap = {
      'TEXT': [ 'blur',function(e, cb){ cb and cb()}]
     // ===  'TEXT': [ 'blur']
     // ===  'TEXT': 'blur'
    }
    provider.setEventsMap(eventMap)
  }])
```

> Note:
> element type include TEXT, SELECT, CHECKBOX, RADIO
> event list support html events
> http://www.w3.org/TR/2000/REC-DOM-Level-2-Events-20001113/events.html#Events-eventgroupings-htmlevents

## Other API

### honey.utils
How to use:


```coffeescript
angular.module('app', ['honey.bindHash'])
  .directive('myDirecitve', ['honey.utils', (utils)->
      return function(){
        restrict: "E"
        ....
        link: (scope, element, attrs)->
          //use utils
      }
  ])
  .controller('myCtrl', ['$scope', 'honey.utils', ($scope, utils)->
       // use utils
  ])
```

#### getHashObj

Get the hash json object. eg.

```coffeescript
  # url = "http://...#a=1&b=2"
  # if $locationProvider.html5Mode is false, maybe url is "http://...#/#a=1&b=2"
  obj = utils.getHashObj()
  # {a:"1", b: "2"}
  #or
  field = utils.getHashObj('a')  # field is '1'
```

#### setHash

set json object to hash

```coffeescript
url = "http://...#a=1&b=2"
params = a: 4, c: 3
utils.setHash params
# url is "http://...#a=4&b=2&c=3"

```

## Demo

  the details see the directory ```sample```

## Test

  Test only on chrome and firefox. other browser is unknown.

## LINCENSE
  MIT

## New

v0.0.3 增加默认值绑定


如下，给表单控件增加默认值。 当页面刷新时， url不存在该控件值的时候，自动绑定到hash。如果存在该值，这默认值忽略。

```
<input type="text" name="email" honey-hash-bind="2"/>
```

例如： ```.../##email=a```, 这个时候，页面刷新完成，上述控件的值是a. 也就是该控件的值存在于url时。
当值不存在时，如```.../##name=b```, 这个时候，页面刷新完成，上述的控件值为2不，并且url变成```../##name=b&&email=2```

注意该方式仅用于常量。 如果绑定上下文请用 ```honey-hash-value```
如： 上级controller有个```$scope.year = 2014``` 需要绑定，那么应该如下使用
```
<input type="text" name="email" honey-hash-value="year"/>
```

原因是在源码定义honey-hash-value组件时，其scope定义如下:
```
scope: {name: '@', honeyHashBind: '@',honeyHashValue: '='}
```

## History

v0.0.1
  init plugin and test.

v0.0.2
  support event config and update README
  
v0.0.3
  增加默认值设置

v0.0.4
  完善上一个版本的功能