// Generated by CoffeeScript 1.9.1
module.exports = function(component, spec) {
  if (spec.query == null) {
    return component.query = function() {
      return {};
    };
  }
  return component.query = function(params) {
    return spec.query.call(component, params);
  };
};
