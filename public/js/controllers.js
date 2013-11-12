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

function MainCtrl($scope, $http, $filter) {
  $scope.newestItems = [];
  $scope.hotItems = [];

  $scope.curPage = 0;
  $scope.pageItems = [];
  $scope.itemsPerPage = 10;

  $http({method: 'GET', url: '/api/templates/'}).
  success(function(data, status, headers, config) {
  $scope.items = data;
  $scope.search();
  }).
  error(function(data, status, headers, config) {
    $scope.items = 'Error!';
  });

  var searchMatch = function (haystack, needle) {
    if (!needle) {
        return true;
    }
    return haystack.toLowerCase().indexOf(needle.toLowerCase()) !== -1;
  };

  // init the filtered items
  $scope.search = function () {
    if(!Array.isArray($scope.items)) return;
    $scope.filteredItems = $filter('filter')($scope.items, function (item) {
        for(var attr in item) {
            if (searchMatch(item[attr], $scope.query))
                return true;
        }
        return false;
    });
    $scope.currentPage = 0;
    // now group by pages
    $scope.groupToPages();
  };
  
  // calculate page in place
  $scope.groupToPages = function () {
      $scope.pagedItems = [];
      
      for (var i = 0; i < $scope.filteredItems.length; i++) {
          if (i % $scope.itemsPerPage === 0) {
              $scope.pagedItems[Math.floor(i / $scope.itemsPerPage)] = [ $scope.filteredItems[i] ];
          } else {
              $scope.pagedItems[Math.floor(i / $scope.itemsPerPage)].push($scope.filteredItems[i]);
          }
      }
  };
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
