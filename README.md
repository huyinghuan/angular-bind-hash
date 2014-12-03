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
> Note:
> element type include TEXT, SELECT, CHECKBOX, RADIO
> event list support html events
> http://www.w3.org/TR/2000/REC-DOM-Level-2-Events-20001113/events.html#Events-eventgroupings-htmlevents

## Demo

  the details see the directory ```sample```

## Test

  Test only on chrome and firefox. other browser is unknown.

## LINCENSE
  MIT

## History

v0.0.1
  init plugin and test.

v0.0.2
  support event config and update README
