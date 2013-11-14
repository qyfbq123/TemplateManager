// 计算字符串长度，中文算长度为2
function calcLen(str) {
  var len = 0;
  for(i = 0; i < str.length; i++) {
    if( str.charCodeAt(i) > 256 ) {
      len += 2;
    } else {
      len ++;
    }
  }
  return len;
}

function cutText(str, size) {
  var len = str.length;
  var _len = 0;
  for( var i = 0; i < len; i++ ) {
    if( str.charCodeAt(i) > 256 ) {
      _len += 2;
    } else {
      _len ++;
    }
    if( _len >= size ) break;
  }
  if(str == 'Gmail邮箱')console.log(i);
        if(str == 'Gmail邮箱') console.log(str.substring(0, i + 1));
  if(i < len - 1) {
    var _i = i;
    for( i; i >= 0; i--) {
      if( /[^a-zA-Z0-9]/.test(str[i]) || str.charCodeAt(i) > 256 ) {
        return str.substring(0, i + 1) + '...';
      }
    }
    for( i=_i; i < len; i++) {
      if( /[^a-zA-Z0-9]/.test(str[i]) || str.charCodeAt(i) > 256 ) {
        return str.substring(0, i) + '...';
      }
    }
  }
  return str;
}
