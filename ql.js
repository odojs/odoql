// Generated by CoffeeScript 1.8.0
var async, diffisdelete, eq, extend, jsondiffpatch, merge, ql,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

extend = require('extend');

jsondiffpatch = require('jsondiffpatch');

async = require('odo-async');

eq = function(a, b) {
  var aarray, akeys, barray, bkeys, i, key, value, _i, _ref;
  if (a === b) {
    return true;
  }
  if (typeof a !== 'object' || typeof b !== 'object') {
    return false;
  }
  if (a === null || b === null) {
    return false;
  }
  aarray = a instanceof Array;
  barray = b instanceof Array;
  if (aarray !== barray) {
    return false;
  }
  if (aarray) {
    if (a.length !== b.length) {
      return false;
    }
    for (i = _i = 0, _ref = a.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
      if (!eq(a[i], b[i])) {
        return false;
      }
    }
    return true;
  }
  akeys = Object.keys(a);
  bkeys = Object.keys(b);
  if (akeys.length !== bkeys.length) {
    return false;
  }
  for (key in a) {
    value = a[key];
    if (!eq(value, b[key])) {
      return false;
    }
  }
  return true;
};

merge = function(base, extra) {
  var aarray, barray, key, value, _results;
  aarray = base instanceof Array;
  barray = extra instanceof Array;
  if (aarray) {
    if (!barray) {
      console.log('Not an array, ignoring');
      console.log(extra);
      return base;
    }
    if (base.length !== 1 || extra.length !== 1) {
      console.log('Expecting length 1 arrays');
      console.log(extra);
      return base;
    }
    return [merge(base[0], extra[0])];
  }
  if (base.__query != null) {
    if (extra.__query == null) {
      console.log('Non query, ignoring');
      console.log(extra);
      return base;
    }
    if (!eq(base.__params, extra.__params)) {
      console.log('Query does not match, ignoring');
      console.log(extra);
      return base;
    }
    if ((base.__shape == null) || (extra.__shape == null)) {
      return base;
    }
    merge(base.__shape, extra.__shape);
    return;
  } else if (extra.__query != null) {
    console.log('Query, ignoring');
    console.log(extra);
    return base;
  }
  _results = [];
  for (key in extra) {
    value = extra[key];
    if ((base[key] != null) && typeof value === 'object') {
      merge(base[key], value);
      continue;
    }
    _results.push(base[key] = value);
  }
  return _results;
};

diffisdelete = function(diff) {
  return diff instanceof Array && diff.length === 3 && diff[1] === 0 && diff[2] === 0;
};

ql = {
  query: function(name, params, shape) {
    return {
      __query: name,
      __params: params,
      __shape: shape
    };
  },
  freshquery: function(name, params, shape) {
    return {
      __query: name,
      __params: params,
      __shape: shape,
      __fresh: true
    };
  },
  describe: function(query) {
    if (Object.keys(query).length === 0) {
      return '-- no query --';
    }
    return 'query\n' + Object.keys(query).map(function(prop) {
      return "  " + prop + " from " + query[prop].__query;
    }).join('\n');
  },
  merge: function(queries) {
    var query, result, _i, _len;
    if (arguments.length === 0) {
      return null;
    }
    if (arguments.length !== 1) {
      queries = Array.prototype.slice.call(arguments, 0);
    }
    if (queries.length === 0) {
      return null;
    }
    result = {};
    for (_i = 0, _len = queries.length; _i < _len; _i++) {
      query = queries[_i];
      merge(result, extend({}, query));
    }
    return result;
  },
  split: function(query, names) {
    var key, known, unknown, value, _ref;
    known = {};
    unknown = {};
    for (key in query) {
      value = query[key];
      if (_ref = value.__query, __indexOf.call(names, _ref) >= 0) {
        known[key] = value;
      } else {
        unknown[key] = value;
      }
    }
    return {
      known: known,
      unknown: unknown
    };
  },
  diff: function(prev, next) {
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
  },
  build: function(query, stores) {
    var graph, item, key, queries, result, _, _fn, _ref;
    queries = {};
    query = ql.split(query, Object.keys(stores));
    _ref = query.known;
    for (key in _ref) {
      graph = _ref[key];
      if (queries[graph.__query] == null) {
        queries[graph.__query] = {
          __query: graph.__query,
          keys: [],
          queries: {}
        };
      }
      queries[graph.__query].keys.push(key);
      queries[graph.__query].queries[key] = graph;
    }
    result = [];
    _fn = function(item) {
      item.query = function(cb) {
        return stores[item.__query](item.queries, cb);
      };
      return result.push(item);
    };
    for (_ in queries) {
      item = queries[_];
      _fn(item);
    }
    if (Object.keys(query.unknown).length === 0) {
      return result;
    }
    if (stores.__dynamic == null) {
      return cb(new Error('Unknown queries'));
    }
    result.push({
      __query: '__dynamic',
      keys: Object.keys(query.unknown),
      query: function(cb) {
        return stores.__dynamic(query.unknown, cb);
      },
      queries: query.unknown
    });
    return result;
  },
  exec: function(query, stores, callback) {
    var errors, q, state, tasks, _fn, _i, _len;
    query = ql.build(query, stores);
    console.log(query);
    errors = [];
    tasks = [];
    state = {};
    _fn = function(q) {
      return tasks.push(function(cb) {
        return q.query(function(err, results) {
          if (err != null) {
            errors.push(err);
          } else {
            extend(state, results);
          }
          return cb();
        });
      });
    };
    for (_i = 0, _len = query.length; _i < _len; _i++) {
      q = query[_i];
      _fn(q);
    }
    return async.parallel(tasks, function() {
      if (errors.length !== 0) {
        return callback(errors, state);
      }
      return callback(null, state);
    });
  }
};

module.exports = ql;
