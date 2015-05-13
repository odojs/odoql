// Generated by CoffeeScript 1.9.1
var async, extend, visit;

async = require('odo-async');

extend = require('extend');

visit = function(node, nodecb, fincb) {
  if (typeof node !== 'object') {
    return fincb(node);
  }
  return nodecb(node, function(replacement) {
    var fn, key, tasks, value;
    if (replacement != null) {
      return fincb(replacement);
    }
    tasks = [];
    fn = function(key, value) {
      return tasks.push(function(cb) {
        return visit(value, nodecb, function(replacement) {
          node[key] = replacement;
          return cb();
        });
      });
    };
    for (key in node) {
      value = node[key];
      fn(key, value);
    }
    return async.series(tasks, function() {
      return fincb(node);
    });
  });
};

module.exports = {
  params: {
    assign: function(exe, params) {
      var getsource;
      getsource = exe.build(params.__s);
      return function(callback) {
        return getsource(function(err, source) {
          var assi, d, def, i, len, prop, ref, ref1, tasks;
          if (err != null) {
            return cb(err);
          }
          assi = function(data, prop, def) {
            return function(fincb) {
              var fillrefs;
              fillrefs = function(node, cb) {
                var getref;
                if ((node.__q == null) || node.__q !== 'ref') {
                  return cb();
                }
                getref = exe.build(node.__s);
                return getref(function(err, res) {
                  if (err != null) {
                    throw new Error(err);
                  }
                  return cb(data[res]);
                });
              };
              def = extend(true, {}, def);
              return visit(def, fillrefs, function(filled) {
                var getref;
                if (err != null) {
                  return callback(err);
                }
                console.log(filled);
                getref = exe.build(filled);
                return getref(function(err, value) {
                  if (err != null) {
                    return callback(err);
                  }
                  data[prop] = value;
                  return fincb();
                });
              });
            };
          };
          tasks = [];
          if (source instanceof Array) {
            for (i = 0, len = source.length; i < len; i++) {
              d = source[i];
              ref = params.__p;
              for (prop in ref) {
                def = ref[prop];
                tasks.push(assi(d, prop, def));
              }
            }
          } else {
            ref1 = params.__p;
            for (prop in ref1) {
              def = ref1[prop];
              tasks.push(assi(source, prop, def));
            }
          }
          return async.series(tasks, function() {
            return callback(null, source);
          });
        });
      };
    }
  }
};
