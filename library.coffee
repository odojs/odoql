result =
  builtin:
    params: {}
    unary: {}
    binary: {}
    trinary: {}

builtin =
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
  strings:
    params:
      findandreplace: yes
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
    unary:
      ref: yes
      count: yes
      nocache: yes
      one: yes
      oneornone: yes
  types:
    unary:
      asInt: yes
      asFloat: yes
for _, def of builtin
  for type, providers of def
    for provider, _ of providers
      result.builtin[type][provider] = yes


result.csv =
  params:
    csv: yes
result.fs =
  params:
    file: yes
result.http =
  params:
    http: yes
result.time =
  unary:
    asTime: yes
  params:
    formatTime: yes
    deltaTime: yes

module.exports = result
