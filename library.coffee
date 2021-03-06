result =
  builtin:
    params: {}
    unary: {}
    binary: {}
    trinary: {}

builtin =
  exe:
    unary:
      literal: yes
  assign:
    params:
      assign: yes
  boolean:
    binary:
      or: yes
      and: yes
      gt: yes
      gte: yes
      lt: yes
      lte: yes
      eq: yes
    unary:
      not: yes
  conditional:
    trinary:
      if: yes
      unless: yes
  fill:
    params:
      fill: yes
    unary:
      param: yes
  filter:
    params:
      filter: yes
  maths:
    binary:
      add: yes
      sub: yes
      div: yes
      mult: yes
      mod: yes
      pow: yes
      atan2: yes
    unary:
      abs: yes
      acos: yes
      asin: yes
      atan: yes
      ceil: yes
      cos: yes
      exp: yes
      floor: yes
      log: yes
      round: yes
      sin: yes
      sqrt: yes
      tan: yes
    params:
      interpolate_linear: yes
      toFixed: yes
      round10: yes
      floor10: yes
      ceil10: yes
  strings:
    params:
      findandreplace: yes
      template: yes
    unary:
      uppercase: yes
      lowercase: yes
      toString: yes
    binary:
      concat: yes
    trinary:
      substr: yes
  transform:
    params:
      pluck: yes
      remove: yes
      shape: yes
      rename: yes
      options: yes
    unary:
      ref: yes
      count: yes
      one: yes
      oneornone: yes
  types:
    unary:
      asInt: yes
      asFloat: yes
  json:
    unary:
      json: yes

for _, def of builtin
  for type, providers of def
    for provider, _ of providers
      result.builtin[type][provider] = yes

# odoql-csv
result.csv =
  params:
    csv: yes
# odoql-fs
result.fs =
  params:
    file: yes
# odoql-http
result.http =
  params:
    http: yes
# odoql-time
result.time =
  unary:
    time_coerce: yes
  params:
    time: yes
    time_utc: yes
    time_format: yes
    time_delta: yes
    time_fill: yes
    time_nudge: yes
# odoql-json
result.json =
  unary:
    json: yes
# odoql-yaml
result.yaml =
  unary:
    yaml: yes
# odoql-localstorage
result.localstorage =
  unary:
    localstorage: yes
# odoql-store
result.store =
  params:
    store: yes

module.exports = result
