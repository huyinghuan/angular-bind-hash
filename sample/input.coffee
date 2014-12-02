angular.module('app', ['honey.hashBind'])
  .controller('TestCtrl', ['$scope', '$timeout', ($scope, $timeout)->
      $scope.list = [1,2,3]
      $scope.bind = ->
        $scope.$broadcast('honey:bindValueToHash')
      $timeout(
        -> $scope.list = [1,2,3,4]
      , 500
      )
    ])

angular.bootstrap(document, ['app'])