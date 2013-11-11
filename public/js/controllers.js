'use strict';

function AppCtrl($scope, $http, $window, $location) {

  $http({method: 'GET', url: '/api/categories/'}).
  success(function(data, status, headers, config) {
    $scope.categories = data;
  }).
  error(function(data, status, headers, config) {
    $scope.categories = 'Error!';
  });
  $scope.navClick = function(e) {
    jQuery('ul>li.active').removeClass('active');
    jQuery(e.target).closest('li').addClass('active');
  };

  $scope.tooltip = {title: "Hello Tooltip<br />This is a multiline message!", checked: false};
}

function MainCtrl($scope, $http) {
  $http({method: 'GET', url: '/api/templates/sort/'}).
  success(function(data, status, headers, config) {
  $scope.sortedTemplates = data;
  console.log(JSON.stringify(data));
  }).
  error(function(data, status, headers, config) {
    $scope.templates = 'Error!';
  });
}

function SubCtrl($scope, $routeParams, $http) {
  var category = $routeParams.category;
  $http({method: 'GET', url: '/api/templates/' + category + '/'}).
    success(function(data, status, headers, config) {
      $scope.subTemplates = data;
    }).
    error(function(data, status, headers, config) {
      $scope.templates = 'Error!';
    });
}

function SingleCtrl() {
  
}
