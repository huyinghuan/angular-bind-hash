(function() {
  angular.module('honey.hashBind', []).factory('honey.utils', [
    '$location', function($location) {
      return {
        serialize: function(obj) {
          var key, queue, value;
          queue = [];
          for (key in obj) {
            value = obj[key];
            queue.push(key + "=" + value);
          }
          return queue.join('&');
        },
        unserialize: function(hash) {
          var e, item, obj, query, queue, _i, _len, _results;
          if ((!hash) || (hash === '')) {
            return {};
          }
          hash = hash.replace(/^#/, '');
          obj = {};
          try {
            queue = hash.split('&');
            _results = [];
            for (_i = 0, _len = queue.length; _i < _len; _i++) {
              query = queue[_i];
              item = query.split('=');
              _results.push(obj[item[0]] = item[1]);
            }
            return _results;
          } catch (_error) {
            e = _error;
          } finally {
            return obj;
          }
        },
        indexOf: function(arr, item) {
          var index, value, _i, _len;
          arr = arr || [];
          for (index = _i = 0, _len = arr.length; _i < _len; index = ++_i) {
            value = arr[index];
            if (value === item) {
              return index;
            }
          }
          return -1;
        },
        setHash: function(obj) {
          var params;
          params = this.unserialize($location.hash());
          params = angular.extend(params, obj);
          return $location.hash(this.serialize(params));
        },
        getHashObj: function(filed) {
          var obj;
          obj = this.unserialize($location.hash());
          if (filed) {
            return obj[filed];
          }
          return obj;
        },
        bindValueToHash: function(key, value) {
          var params;
          params = this.unserialize($location.hash());
          params[key] = value;
          return $location.hash(this.serialize(params));
        },
        bindHashToInput: function(element, value) {
          return element.val(value);
        },
        bindHashToSelect: function(element, value) {
          var option, options, _i, _len, _results;
          options = element.find('option');
          _results = [];
          for (_i = 0, _len = options.length; _i < _len; _i++) {
            option = options[_i];
            if (option.value === value) {
              option.selected = 'selected';
              break;
            } else {
              _results.push(void 0);
            }
          }
          return _results;
        },
        bindHashToOption: function(element, key) {
          var params;
          params = this.unserialize($location.hash());
          if (!params[key]) {
            return;
          }
          if (element.val() === params[key]) {
            return element.attr('selected', 'selected');
          }
        },
        bindHashToRadio: function(element, value) {
          if (element.val() === value) {
            return element.attr('checked', true);
          }
        },
        bindHashToCheckbox: function(element, value) {
          var box, queue, _i, _len, _results;
          queue = [];
          if (value) {
            queue = value.split(',');
          }
          _results = [];
          for (_i = 0, _len = queue.length; _i < _len; _i++) {
            box = queue[_i];
            if (element.val() === box) {
              element.attr('checked', true);
              break;
            } else {
              _results.push(void 0);
            }
          }
          return _results;
        },
        bindInputToHash: function(key, value) {
          return this.bindValueToHash(key, value);
        },
        bindSelectToHash: function(key, value) {
          return this.bindValueToHash(key, value);
        },
        bindRadioToHash: function(key, value, status) {
          if (status) {
            return this.bindValueToHash(key, value);
          }
        },
        bindCheckboxToHash: function(key, value, status) {
          var index, item, newValue, oldValue, params, _i, _len;
          params = this.unserialize($location.hash());
          oldValue = params[key] || '';
          oldValue = oldValue === '' ? [] : oldValue.split(',');
          if (status) {
            index = this.indexOf(oldValue, value);
            if (index === -1) {
              oldValue.push(value);
            }
          } else {
            for (index = _i = 0, _len = oldValue.length; _i < _len; index = ++_i) {
              item = oldValue[index];
              if (item === value) {
                oldValue.splice(index, 1);
                break;
              }
            }
          }
          newValue = oldValue.join(',');
          if (newValue === '') {
            delete params[key];
          } else {
            params[key] = newValue;
          }
          return $location.hash(this.serialize(params));
        }
      };
    }
  ]).provider('hashBind', function() {
    var T, eventsMap, isListener;
    eventsMap = {
      'TEXT': [
        'keyup', function(e, cb) {
          if (e.keyCode === 13) {
            e.preventDefault();
            return cb && cb();
          }
        }
      ],
      'SELECT': [
        'change', function(e, cb) {
          return cb && cb();
        }
      ],
      'RADIO': [
        'click', function(e, cb) {
          return cb && cb();
        }
      ],
      'CHECKBOX': [
        'click', function(e, cb) {
          return cb && cb();
        }
      ]
    };
    isListener = {
      'TEXT': true,
      'SELECT': true,
      'RADIO': true,
      'CHECKBOX': true
    };
    T = (function() {
      function T() {}

      T.prototype.getLisener = function(eleType) {
        return eventsMap[eleType];
      };

      T.prototype.hasLisener = function(eleType) {
        return isListener[eleType];
      };

      return T;

    })();
    this.setEventsMap = function(map) {
      var key, value, _results;
      _results = [];
      for (key in map) {
        value = map[key];
        if (typeof value === 'boolean') {
          _results.push(isListener[key] = value);
        } else {
          value = [].concat(value);
          if (value.length === 1) {
            value[1] = function(e, cb) {
              return cb && cb();
            };
          }
          _results.push(eventsMap[key] = value);
        }
      }
      return _results;
    };
    this.$get = function() {
      return new T();
    };
    return this;
  }).directive('honeyHashBind', [
    '$timeout', 'honey.utils', 'hashBind', function($timeout, utils, config) {
      return {
        restrict: 'A',
        replace: false,
        scope: {
          name: '@',
          honeyHashBind: '@',
          honeyHashValue: '='
        },
        link: function($scope, element, attrs) {
          var attrName, bindEvent, bindHashToElement, bindValueToHash, checkDefaultValue, eleType;
          attrName = $scope.name;
          eleType = "";
          checkDefaultValue = function() {
            var defaultValue, field, obj;
            defaultValue = $scope.honeyHashBind || $scope.honeyHashValue;
            if (defaultValue != null) {
              field = utils.getHashObj(attrName);
              if (!field) {
                obj = {};
                obj[attrName] = defaultValue;
                utils.setHash(obj);
              }
            }
            if (element[0].tagName.toUpperCase() !== 'INPUT') {
              return eleType = element[0].tagName.toUpperCase();
            } else {
              return eleType = element[0].type.toUpperCase();
            }
          };
          bindHashToElement = function() {
            var value;
            value = utils.getHashObj(attrName);
            switch (eleType) {
              case 'TEXT':
                return utils.bindHashToInput(element, value);
              case 'SELECT':
                return utils.bindHashToSelect(element, value);
              case 'RADIO':
                return utils.bindHashToRadio(element, value);
              case 'CHECKBOX':
                return utils.bindHashToCheckbox(element, value);
              case 'OPTION':
                return $scope.$evalAsync(function() {
                  return utils.bindHashToOption(element, element.parent().attr('name'));
                });
              default:
                return utils.bindHashToInput(element, value);
            }
          };
          bindValueToHash = function() {
            var value;
            value = element.val();
            switch (eleType) {
              case 'TEXT':
                return utils.bindInputToHash(attrName, value);
              case 'SELECT':
                return utils.bindSelectToHash(attrName, value);
              case 'RADIO':
                return utils.bindRadioToHash(attrName, value, element[0].checked);
              case 'CHECKBOX':
                return utils.bindCheckboxToHash(attrName, value, element[0].checked);
              case 'OPTION':
                return 0;
              default:
                return utils.bindInputToHash(attrName, value);
            }
          };
          $scope.$on('honey:bindHashToElement', function(event, type) {
            return bindHashToElement();
          });
          $scope.$on('honey:bindValueToHash', function() {
            return bindValueToHash();
          });
          bindEvent = function() {
            var eventFun, eventName, islistener, listener;
            islistener = config.hasLisener(eleType);
            if (islistener !== true) {
              return;
            }
            listener = config.getLisener(eleType);
            eventName = listener[0];
            eventFun = listener[1];
            return element[0].addEventListener(eventName, function(e) {
              return eventFun(e, function() {
                return $scope.$apply(bindValueToHash);
              });
            });
          };
          return $timeout(function() {
            checkDefaultValue();
            bindHashToElement();
            return bindEvent();
          });
        }
      };
    }
  ]);

}).call(this);
