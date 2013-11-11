'use strict';

angular.module('myApp', ['ngRoute', '$strap.directives', 'myApp.filters']).
  config(function($routeProvider, $locationProvider) {
  $routeProvider.when('/', {templateUrl: '/templates/', controller: MainCtrl});
  $routeProvider.when('/templates', {templateUrl: '/templates/', controller: MainCtrl});
  $routeProvider.when('/subTemplates/:category', {templateUrl: '/subTemplates/', controller: SubCtrl});
  $routeProvider.when('/template:id/', {templateUrl: '/template/', controller: SingleCtrl});
  $locationProvider.html5Mode(true);
});