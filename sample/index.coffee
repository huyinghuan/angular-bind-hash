angular.module('app', ['honey.hashBind'])
  .config(['hashBindProvider', (provider)->
    eventMap =
      'SELECT': false
      'TEXT':[
        'blur'
        (e, cb)-> cb and cb()
      ]
    provider.setEventsMap eventMap
  ])
  .controller('TestCtrl', ['$scope', '$timeout', ($scope, $timeout)->
      $scope.list = [1,2,3]
      $scope.bind = ->
        $scope.$broadcast('honey:bindValueToHash')

      $scope.refresh = ->
        window.location.reload()

      $timeout(
        -> $scope.list = [1,2,3,4]
      , 500
      )


    ])

angular.bootstrap(document, ['app'])