// Generated by CoffeeScript 1.8.0
var extend;

extend = require('extend');

module.exports = function(el, component, store) {
  var Relay, memory, query, scene, state;
  scene = null;
  memory = {};
  query = {};
  state = {};
  Relay = {
    mount: function() {
      return scene = component.mount(el, state, memory);
    },
    update: function(params, cb) {
      return Relay.refreshAll(params, function(err) {
        if (err != null) {
          if (cb != null) {
            cb(err);
          }
          return;
        }
        if (scene == null) {
          Relay.mount();
        } else {
          scene.update(state, memory);
        }
        if (cb != null) {
          return cb();
        }
      });
    },
    refreshAll: function(params, cb) {
      Relay.updateParams(params);
      return Relay.executeQuery(cb);
    },
    updateParams: function(params) {
      return extend(memory, params);
    },
    executeQuery: function(cb) {
      var newquery;
      newquery = component.query(memory);
      return store(query, state, newquery, function(err, result) {
        if (err != null) {
          return cb(err);
        }
        state = result;
        query = newquery;
        return cb();
      });
    },
    unmount: function() {
      scene.unmount();
      return scene = null;
    },
    params: function() {
      return memory;
    }
  };
  return Relay;
};