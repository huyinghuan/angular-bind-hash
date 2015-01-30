angular.module('app', ['honey.hashBind'])
  .config(['hashBindProvider', (provider)->
    eventMap =
      'TEXT': 'blur'
    provider.setEventsMap eventMap
  ])
  .controller('TestCtrl', ['$scope', '$timeout', ($scope, $timeout)->
      $scope.list = [1,2,3]
      $scope.birth = "birth"
      $scope.year = "bind20314"
      $scope.bind = ->
        $scope.$broadcast('honey:bindValueToHash')

      $scope.refresh = ->
        window.location.reload()

      $timeout(
        -> $scope.list = [1,2,3,4]
      , 500
      )
    ])
  .directive('test', ->
    restrict: 'E'
    replace: true
    scope: {}
    templateUrl: "directive-test.html"
    link: ($scope, element, attribute)->
      $scope.year = 2016

  )

angular.bootstrap(document, ['app'])