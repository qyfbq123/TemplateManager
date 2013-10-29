'use strict';

function AppCtrl($scope, $http) {

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
}

function MainCtrl($scope, $http) {
  $http({method: 'GET', url: '/api/templates/sort/'}).
  success(function(data, status, headers, config) {
  $scope.sortedTemplates = data;
  }).
  error(function(data, status, headers, config) {
    $scope.templates = 'Error!';
  });
}

function SubCtrl($scope, $routeParams) {
  var category = $routeParams.category;
}