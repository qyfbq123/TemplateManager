'use strict';

/* Filters */

angular.module('myApp.filters', []).
  filter('omitted', function() {
    return function(text, size) {
      size =  size || 10;
      return cutText( String(text), size );
    };
  });
