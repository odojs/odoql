# OdoQL

OdoQL is an extendible, composable and modular JSON query language.

This module (odoql) can build JSON queries with no additional dependencies. Use odoql-exe and other providers to execute queries. Or build additional execution environments in languages other than javascript.

- [OdoQL Examples](https://github.com/odojs/odoql/tree/master/examples) contain some good examples of the OdoQL syntax.
- [Odo.js Handbook](https://github.com/odojs/odojs-handbook) is a good example of how OdoQL can be used in a web framework.


# Usage

Define a query
```js
var ql = require('odoql');
ql = ql
  .use('csv')
  .use('http');

var query = ql('http://samplecsvs.s3.amazonaws.com/Sacramentorealestatetransactions.csv')
  .http()
  .csv({
    header: true,
    skipEmptyLines: true
  })
  .assign({
    sq__ft: ql.asFloat(ql.ref('sq__ft'))
  })
  .filter(ql.gt(ql.ref('sq__ft'), 1000))
  .shape({
    street: true
  })
  .query();

console.log(JSON.stringify(query, null, 2));
```

Raw JSON format can be sent to a server or saved.
```
{
  "__q": "shape",
  "__p": {
    "street": true
  },
  "__s": {
    "__q": "filter",
    "__p": {
      "__q": "gt",
      "__l": {
        "__q": "ref",
        "__s": "sq__ft"
      },
      "__r": 1000
    },
    "__s": {
      "__q": "assign",
      "__p": {
        "sq__ft": {
          "__q": "asFloat",
          "__s": {
            "__q": "ref",
            "__s": "sq__ft"
          }
        }
      },
      "__s": {
        "__q": "csv",
        "__p": {
          "header": true,
          "skipEmptyLines": true
        },
        "__s": {
          "__q": "http",
          "__s": "http://samplecsvs.s3.amazonaws.com/Sacramentorealestatetransactions.csv"
        }
      }
    }
  }
}
```

Execute a JSON query:
```js
var exe = require('odoql-exe');
exe = exe()
  .use(require('odoql-csv'))
  .use(require('odoql-http'));

var run = exe.build(query);

run(function(err, results) {
  console.log(results);
});
```

This is just the start, see [OdoQL Exe](https://github.com/odojs/odoql-exe) source for other components including caching, dynamic queries and parrallel queries.
See [Odo Relay](https://github.com/odojs/odo-relay) to integrate OdoQL into [Odo.js](https://github.com/odojs/odojs)
