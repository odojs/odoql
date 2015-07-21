// Generated by CoffeeScript 1.9.2
var _, builtin, def, provider, providers, result, type;

result = {
  builtin: {
    params: {},
    unary: {},
    binary: {},
    trinary: {}
  }
};

builtin = {
  exe: {
    unary: {
      literal: true
    }
  },
  assign: {
    params: {
      assign: true
    }
  },
  boolean: {
    binary: {
      or: true,
      and: true,
      gt: true,
      gte: true,
      lt: true,
      lte: true,
      eq: true
    },
    unary: {
      not: true
    }
  },
  conditional: {
    trinary: {
      "if": true,
      unless: true
    }
  },
  fill: {
    params: {
      fill: true
    },
    unary: {
      param: true
    }
  },
  filter: {
    params: {
      filter: true
    }
  },
  maths: {
    binary: {
      add: true,
      sub: true,
      div: true,
      mult: true,
      mod: true,
      pow: true,
      atan2: true
    },
    unary: {
      abs: true,
      acos: true,
      asin: true,
      atan: true,
      ceil: true,
      cos: true,
      exp: true,
      floor: true,
      log: true,
      round: true,
      sin: true,
      sqrt: true,
      tan: true
    }
  },
  strings: {
    params: {
      findandreplace: true,
      template: true
    },
    unary: {
      uppercase: true,
      lowercase: true,
      toString: true
    },
    binary: {
      concat: true
    },
    trinary: {
      substr: true
    }
  },
  transform: {
    params: {
      pluck: true,
      remove: true,
      shape: true,
      rename: true,
      options: true
    },
    unary: {
      ref: true,
      count: true,
      one: true,
      oneornone: true
    }
  },
  types: {
    unary: {
      asInt: true,
      asFloat: true
    }
  }
};

for (_ in builtin) {
  def = builtin[_];
  for (type in def) {
    providers = def[type];
    for (provider in providers) {
      _ = providers[provider];
      result.builtin[type][provider] = true;
    }
  }
}

result.csv = {
  params: {
    csv: true
  }
};

result.fs = {
  params: {
    file: true
  }
};

result.http = {
  params: {
    http: true
  }
};

result.time = {
  unary: {
    asTime: true
  },
  params: {
    parseTime: true,
    formatTime: true,
    deltaTime: true
  }
};

result.json = {
  unary: {
    json: true
  }
};

result.yaml = {
  unary: {
    yaml: true
  }
};

result.localstorage = {
  unary: {
    localstorage: true
  }
};

result.store = {
  params: {
    store: true
  }
};

module.exports = result;
