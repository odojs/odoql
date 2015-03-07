// Generated by CoffeeScript 1.8.0
var executequery, fillproperties, fillproperty, jsonfilter;

jsonfilter = require('./json-filter');

fillproperty = function(data, graph, subqueries) {
  if (graph.__odoql != null) {
    return subqueries[graph.__odoql.name](data, graph, subqueries);
  } else {
    return fillproperties(data, graph, subqueries);
  }
};

fillproperties = function(data, graph, subqueries) {
  var key, result, shape;
  if ((data == null) || data === null) {
    return null;
  }
  if (typeof graph !== 'object') {
    return data;
  }
  result = {};
  for (key in graph) {
    shape = graph[key];
    if (data[key] == null) {
      continue;
    }
    if (!(shape instanceof Array)) {
      result[key] = fillproperty(data[key], shape, subqueries);
      continue;
    }
    if (!(data[key] instanceof Array)) {
      throw Error('Expecting array found ' + typeof data);
    }
    shape = shape[0];
    result[key] = data[key].map(function(d) {
      return fillproperty(d, shape, subqueries);
    });
  }
  return result;
};

executequery = function(data, graph, subqueries) {
  var results;
  if (graph.graph instanceof Array) {
    results = jsonfilter(data, graph.__odoql.filter);
    results = results.map(function(result) {
      return fillproperties(result, graph.graph[0], subqueries);
    });
    return results;
  }
  results = jsonfilter(data, graph.__odoql.filter);
  results = results.map(function(result) {
    return fillproperties(result, graph.graph, subqueries);
  });
  if (results.length === 0) {
    return null;
  }
  if (results.length !== 1) {
    throw new Error('One needed, many found');
  }
  return results[0];
};

module.exports = executequery;
