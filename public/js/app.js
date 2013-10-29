'use strict';

angular.module('myApp', ['ngRoute']).
  config(function($routeProvider, $locationProvider) {
  $routeProvider.when('/', {templateUrl: '/templates/', controller: MainCtrl});
  $routeProvider.when('/templates', {templateUrl: '/templates/', controller: MainCtrl});
  $routeProvider.when('/subTemplates/:category', {templateUrl: '/subTemplates/', controller: SubCtrl});
  $locationProvider.html5Mode(true);
});