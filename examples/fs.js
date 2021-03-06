// Generated by CoffeeScript 1.9.1
var exe, ql, query, run;

ql = require('odoql');

ql = ql.use('csv').use('fs');

query = ql('./example.csv').file().csv({
  header: true,
  skipEmptyLines: true
}).assign({
  wsp: ql.asFloat(ql.ref('wsp'))
}).filter(ql.gt(ql.ref('wsp'), 6)).shape({
  wd: true
}).query();

console.log(JSON.stringify(query, null, 2));

exe = require('odoql-exe');

exe = exe().use(require('odoql-csv')).use(require('odoql-fs'));

run = exe.build(query);

run(function(err, results) {
  return console.log(results);
});
