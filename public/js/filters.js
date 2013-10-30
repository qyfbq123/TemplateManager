'use strict';

/* Filters */

angular.module('myApp.filters', []).
  filter('omitted', function() {
    return function(text, size) {
      size =  size || 10;
      if( text.length > size ) return String(text).substring(0, size) + '...';
      else return text;
    };
  });
