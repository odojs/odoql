// Generated by CoffeeScript 1.8.0
var diffisdelete, jsondiffpatch;

jsondiffpatch = require('jsondiffpatch');

diffisdelete = function(diff) {
  return diff instanceof Array && diff.length === 3 && diff[1] === 0 && diff[2] === 0;
};

module.exports = function(prev, next) {
  var diff, key, result, value;
  result = {};
  diff = jsondiffpatch.diff(prev, next);
  for (key in diff) {
    value = diff[key];
    if (diffisdelete(value)) {
      continue;
    }
    result[key] = next[key];
  }
  for (key in next) {
    value = next[key];
    if ((value != null ? value.__fresh : void 0) != null) {
      result[key] = value;
    }
  }
  return result;
};