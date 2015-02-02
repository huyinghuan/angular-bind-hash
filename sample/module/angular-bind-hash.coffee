angular.module('honey.hashBind', [])
  .provider('honey.bind', ->

    serialize = (obj)->
      queue = []
      queue.push "#{key}=#{value}" for key, value of obj
      queue.join '&'

    unserialize = (hash)->
      return {} if (not hash) or (hash is '')
      hash = hash.replace /^#/, ''
      obj = {}
      try
        queue = hash.split '&'
        for query in queue
          item = query.split('=')
          obj[item[0]] =  item[1]
      catch e
      finally
        return obj

    #事件映射
    eventsMap =
      'TEXT': [
        'keyup'
        (e, cb)->
          if e.keyCode is 13
            e.preventDefault()
            cb and cb()
      ]
      'SELECT': ['change', (e, cb)-> cb and cb()]
      'RADIO': ['click', (e, cb)-> cb and cb()]
      'CHECKBOX': ['click', (e, cb)-> cb and cb()]

    isListener =
      'TEXT': true
      'SELECT': true
      'RADIO': true
      'CHECKBOX': true

    $location = null

    #绑定值
    bindValueToPath = (params)->
      $location.hash serialize params

    getPathValue = ->
      unserialize $location.hash()

    class T
      constructor: (depency)->
        $location = depency

      getLisener: (eleType)->
        eventsMap[eleType]

      hasLisener: (eleType)->
        isListener[eleType]

      serialize: serialize

      unserialize: unserialize

      setPathParams: (params)-> bindValueToPath params

      getPathParams: -> getPathValue()

    @setEventsMap = (map)->
      for key, value of map
        if typeof value is 'boolean'
          isListener[key] = value
        else
          value = [].concat(value)
          if value.length is 1
            value[1] = (e, cb)-> cb and cb()
          eventsMap[key] = value

    @setBindAction = (action)->
      bindValueToPath = action

    @setGetAction = (action)->
      getPathValue = action

    @$get = new T()

    #coffee 坑
    return @
  )
  .factory('honey.utils',['honey.bind', (hashBind)->
    serialize: hashBind.serialize
    unserialize: hashBind.unserialize
    indexOf: (arr, item)->
      arr = arr or []
      for value, index in arr
        return index if value is item
      return -1

    setPathParams: (params)->
      hashBind.setPathParams(params)

    getPathParams: ->
      hashBind.getPathParams()

    setHash: (obj)->
      params = @getPathParams()
      params = angular.extend params, obj
      @setPathParams params

    getHashObj: (filed)->
      obj = @getPathParams()
      return obj[filed] if filed
      return obj

    bindValueToHash: (key, value)->
      params = @getPathParams()
      params[key] = value
      @setPathParams params

    bindHashToInput: (element, value)->
      element.val(value)

    bindHashToSelect: (element, value)->
      options = element.find('option')
      for option in options
        if option.value is value
          option.selected = 'selected'
          break

    bindHashToOption: (element, key)->
      params = @getPathParams()
      return if not params[key]
      if element.val() is params[key]
        element.attr('selected', 'selected')

    bindHashToRadio: (element, value)->
      if element.val() is value
        element.attr('checked', true)

    bindHashToCheckbox: (element, value)->
      queue = []
      queue = value.split(',') if value
      for box in queue
        if element.val() is box
          element.attr('checked', true)
          break

    bindInputToHash: (key, value)->
      @bindValueToHash key, value

    bindSelectToHash: (key, value)->
      @bindValueToHash key, value

    bindRadioToHash: (key, value, status)->
      @bindValueToHash key, value if status

    bindCheckboxToHash: (key, value, status)->
      params = @getPathParams()
      oldValue = params[key] or ''
      oldValue = if oldValue is '' then [] else oldValue.split(',')
      if status
        index = @indexOf oldValue, value
        oldValue.push value if index is -1
      else
        for item, index in oldValue
          if item is value
            oldValue.splice index, 1
            break

      newValue = oldValue.join(',')
      if newValue is '' then delete  params[key] else params[key] = newValue
      @setPathParams params
  ])
  .directive('honeyHashBind', ['$timeout', 'honey.utils', 'honey.bind', ($timeout, utils, config)->
    restrict: 'A'
    replace: false
    scope: {
      name: '@'
      honeyHashBind: '@'
      honeyHashValue: '='
    }
    link: ($scope, element, attrs)->
      attrName = $scope.name
      eleType = ""
      checkDefaultValue = ->
        #检查是否存在默认值
        defaultValue = $scope.honeyHashBind or $scope.honeyHashValue
        if defaultValue?
          #检查hash中是否一存在该数据字段
          field = utils.getHashObj(attrName)
          #如果不存在该字段
          if not field
            obj = {}
            obj[attrName] = defaultValue
            utils.setHash(obj)

        if element[0].tagName.toUpperCase() isnt 'INPUT'
          eleType = element[0].tagName.toUpperCase()
        else
          eleType = element[0].type.toUpperCase()



      bindHashToElement = ->
        value = utils.getHashObj attrName
        switch eleType
          when 'TEXT' then utils.bindHashToInput element, value
          when 'SELECT' then utils.bindHashToSelect element, value
          when 'RADIO' then utils.bindHashToRadio element, value
          when 'CHECKBOX' then utils.bindHashToCheckbox element, value
          when 'OPTION'
            $scope.$evalAsync ->
              utils.bindHashToOption element, element.parent().attr('name')
          else utils.bindHashToInput element, value

      bindValueToHash = ()->
        value = element.val()
        switch eleType
          when 'TEXT' then utils.bindInputToHash attrName, value
          when 'SELECT' then utils.bindSelectToHash attrName, value
          when 'RADIO' then utils.bindRadioToHash attrName, value, element[0].checked
          when 'CHECKBOX' then utils.bindCheckboxToHash attrName, value, element[0].checked
          when 'OPTION' then 0
          else utils.bindInputToHash attrName, value

      $scope.$on('honey:bindHashToElement', (event, type)->
        bindHashToElement()
      )

      $scope.$on('honey:bindValueToHash', ->
        bindValueToHash()
      )

      #event bind
      bindEvent = ->
        islistener = config.hasLisener eleType
        return if islistener isnt true
        listener = config.getLisener eleType
        eventName = listener[0]
        eventFun = listener[1]
        element[0].addEventListener(
          eventName
        , (e)->
          #坑。 如果通过apply 调用，则无法更新local值
          eventFun e, ()-> $scope.$apply bindValueToHash
        )
      $timeout(()->
        checkDefaultValue()
        bindHashToElement()
        bindEvent()
      )
  ])