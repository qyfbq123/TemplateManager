'use strict';

/* Filters */

angular.module('myApp', []).
  filter('omitted', function() {
    return function(text, size) {
      if( text.length > size ) return String(text).substring(0, size) + '...';
      else return text;
    };
  });
