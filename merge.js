// Generated by CoffeeScript 1.9.1
var eq, isobject, isquery, merge, notequal, notsametype;

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

merge = function(a, b) {
  var _, aisquery, akeys, aobject, bisquery, bkeys, bobject, key, ref, value;
  aobject = isobject(a);
  bobject = isobject(a);
  if (aobject !== bobject) {
    throw new Error(notsametype(a, b));
  }
  if (!aobject) {
    if (!eq(a, b)) {
      throw new Error(notequal(a, b));
    }
    return a;
  }
  aisquery = isquery(a);
  bisquery = isquery(b);
  if (aisquery !== bisquery) {
    throw new Error(notsametype(a, b));
  }
  akeys = Object.keys(a);
  bkeys = Object.keys(b);
  if (akeys.length !== bkeys.length) {
    throw new Error(notequal(a, b));
  }
  if (!aisquery) {
    for (key in b) {
      value = b[key];
      a[key] = merge(value, b[key]);
    }
    return a;
  }
  if (a.__q !== b.__q) {
    console.log(a);
    console.log(b);
    throw new Error(notequal(a.__q, b.__q));
  }
  if (a.__q === 'shape') {
    ref = b.__p;
    for (key in ref) {
      _ = ref[key];
      a.__p[key] = true;
    }
  } else if (a.__q === 'filter') {
    if (!eq(a.__p, b.__p)) {
      a.__p = {
        __q: 'and',
        __l: a.__p,
        __r: b.__p
      };
    }
  } else {
    if ((a.__p != null) !== (b.__p != null)) {
      throw new Error(notequal(a.__p, b.__p));
    }
    if (a.__p != null) {
      a.__p = merge(a.__p, b.__p);
    }
  }
  for (key in b) {
    value = b[key];
    if (key === '__q' || key === '__p') {
      continue;
    }
    a[key] = merge(a[key], value);
  }
  return a;
};

module.exports = merge;