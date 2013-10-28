'use strict';

function AppCtrl($scope, $http) {
  $http({method: 'GET', url: '/templates/categories/'}).
  success(function(data, status, headers, config) {
    $scope.categories = data;
  }).
  error(function(data, status, headers, config) {
    $scope.categories = 'Error!';
  });
}

function MyCtrl($scope) {

}