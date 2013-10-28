'use strict';

angular.module('myApp', []).
  config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
  $routeProvider.when('/view1', {templateUrl: 'test.html', controller: MyCtrl});
  $locationProvider.html5Mode(true);
}]);