'use strict';

/* Filters */

angular.module('myApp.filters', []).
  filter('omitted', function() {
    return function(text, size) {
      size =  size || 10;
      return cutText( String(text), size );
    };
  }).
  filter('transByte', function(){
    return function(text) {
      var byte = Number(text);
      var KB = 1024;
      var MB = KB * 1024;
      var GB = MB * 1024;
      if(byte < KB) {
        return byte + 'B';
      } else if( byte < MB ) {
        return Math.floor( (byte + KB - 1) / KB ) + 'KB';
      } else if( byte < GB ) {
        return Math.floor( (byte + MB - 1) / MB ) + 'MB';
      } else
        return Math.floor( (byte + GB - 1) / GB ) + 'GB';
    };
  });
