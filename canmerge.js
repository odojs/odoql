// Generated by CoffeeScript 1.9.1
var canmerge, eq, extend, isobject, isquery, notequal, notsametype;

extend = require('extend');

eq = require('./eq');

isquery = require('./isquery');

isobject = function(o) {
  return typeof o === 'object';
};

notequal = function(a, b) {
  return "Could not merge queries " + a + " " + b + " are not equal";
};

notsametype = function(a, b) {
  return "Could not merge queries " + a + " " + b + " are not the same type";
};

canmerge = function(a, b) {
  var aisquery, aobject, bisquery, bobject, key, value;
  aobject = isobject(a);
  bobject = isobject(a);
  if (aobject !== bobject) {
    return false;
  }
  if (!aobject) {
    return eq(a, b);
  }
  aisquery = isquery(a);
  bisquery = isquery(b);
  if (aisquery !== bisquery) {
    return false;
  }
  if (Object.keys(a).length !== Object.keys(b).length) {
    return false;
  }
  if (!aisquery) {
    for (key in b) {
      value = b[key];
      if (!canmerge(value, b[key])) {
        return false;
      }
    }
  }
  if (a.__q !== b.__q) {
    return false;
  }
  if (a.__q === 'shape') {

  } else if (a.__q === 'filter') {

  } else {
    if ((a.__p != null) !== (b.__p != null)) {
      return false;
    }
  }
  for (key in b) {
    value = b[key];
    if (key === '__q' || key === '__p') {
      continue;
    }
    if (!canmerge(a[key], value)) {
      return false;
    }
  }
  return true;
};

module.exports = canmerge;
