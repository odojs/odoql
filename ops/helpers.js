// Generated by CoffeeScript 1.9.1
module.exports = {
  binary: function(exe, params, callback) {
    var getleft, getright;
    getleft = exe.build(params.__left);
    getright = exe.build(params.__right);
    return function(cb) {
      return getleft(function(err, left) {
        if (err != null) {
          return cb(err);
        }
        return getright(function(err, right) {
          if (err != null) {
            return cb(err);
          }
          return cb(null, callback(left, right));
        });
      });
    };
  },
  unary: function(exe, params, callback) {
    var getsource;
    getsource = exe.build(params.__source);
    return function(cb) {
      return getsource(function(err, source) {
        if (err != null) {
          return cb(err);
        }
        return cb(null, callback(source));
      });
    };
  },
  params: function(exe, params, callback) {
    var getparams, getsource;
    getparams = exe.build(params.__params);
    getsource = exe.build(params.__source);
    return function(cb) {
      return getparams(function(err, params) {
        if (err != null) {
          return cb(err);
        }
        return getsource(function(err, source) {
          if (err != null) {
            return cb(err);
          }
          return cb(null, callback(params, source));
        });
      });
    };
  }
};