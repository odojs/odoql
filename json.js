// Generated by CoffeeScript 1.8.0
var fillgraph, filltarget, filterstore, jsonfilter, subqueries;

jsonfilter = require('./json-filter');

subqueries = {};

filltarget = function(graph, item) {
  if (typeof graph !== 'object') {
    return item;
  }
  return fillgraph(graph, item);
};

fillgraph = function(graph, item) {
  var def, key, result, shape, target;
  if ((item == null) || item === null) {
    return null;
  }
  result = {};
  for (key in graph) {
    shape = graph[key];
    if (item[key] == null) {
      continue;
    }
    target = item[key];
    if (shape.__odoql == null) {
      result[key] = filltarget(shape, target);
      continue;
    }
    def = shape.__odoql;
    if (def.query != null) {
      result[key] = subqueries[def.query.name](def, shape, target);
      continue;
    }
    if (def.type === 'array') {
      result[key] = target.map(function(t) {
        return filltarget(shape, t);
      });
      continue;
    }
  }
  return result;
};

filterstore = function(def, graph, data) {
  var results;
  results = jsonfilter(data, def.query.filter);
  results = results.map(function(result) {
    return fillgraph(graph, result);
  });
  if (def.type === 'array') {
    return results;
  }
  if (results.length === 0) {
    return null;
  }
  if (results.length !== 1) {
    throw new Error('One needed, many found');
  }
  return results[0];
};

subqueries['json-filter'] = filterstore;

module.exports = {
  subqueries: subqueries,
  query: filterstore,
  filter: jsonfilter
};
