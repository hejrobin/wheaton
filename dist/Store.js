var EventEmitter, Mutate, Randomize, Store, extend, mutatorsFor, parameterize, serialize,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend1 = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

EventEmitter = require('./EventEmitter');

Randomize = require('./Randomize');

Mutate = require('./Mutate');

extend = Mutate.extend, mutatorsFor = Mutate.mutatorsFor;

parameterize = Mutate.parameterize;

serialize = Mutate.serialize;

Store = (function(superClass) {
  var _dataStore, get, ref, set;

  extend1(Store, superClass);

  ref = mutatorsFor(Store.prototype), get = ref.get, set = ref.set;

  _dataStore = {};

  function Store(dataStore) {
    if (dataStore == null) {
      dataStore = {};
    }
    this.parameterize = bind(this.parameterize, this);
    this.serialize = bind(this.serialize, this);
    this.replace(dataStore);
    return;
  }

  get('data', function() {
    return _dataStore;
  });

  set('data', function(newStore) {
    if (newStore == null) {
      newStore = {};
    }
    return _dataStore = newStore;
  });

  get('size', function() {
    return Object.keys(this.data).length;
  });

  get('keys', function() {
    return Array.prototype.slice.apply(Object.keys(this.data));
  });

  get('shuffledKeys', function() {
    var currentIndex, randomIndex, shuffledKeys, tmp;
    shuffledKeys = this.keys;
    currentIndex = this.size;
    randomIndex = void 0;
    tmp = void 0;
    while (0 !== currentIndex) {
      randomIndex = this.randomKey;
      currentIndex -= 1;
      tmp = shuffledKeys[currentIndex];
      shuffledKeys[currentIndex] = shuffledKeys[randomIndex];
      shuffledKeys[randomIndex] = tmp;
    }
    return shuffledKeys;
  });

  get('values', function() {
    var dataStoreValues;
    dataStoreValues = Object.keys(_dataStore).map((function(_this) {
      return function(key) {
        return _this.data[key];
      };
    })(this));
    return Array.prototype.slice.apply(dataStoreValues);
  });

  get('serialized', function() {
    return this.serialize();
  });

  get('parameterized', function() {
    return this.parameterize();
  });

  get('randomKey', function() {
    return Randomize.pick(this.keys);
  });

  get('firstKey', function() {
    return this.keys[0];
  });

  get('lastKey', function() {
    return this.keys[this.size - 1];
  });

  get('random', function() {
    return this.data[this.randomKey];
  });

  get('first', function() {
    return this.data[this.firstKey];
  });

  get('last', function() {
    return this.data[this.lastKey];
  });

  Store.prototype.has = function() {
    var keys;
    keys = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    return keys.map((function(_this) {
      return function(key) {
        return _this.keys.indexOf(key);
      };
    })(this)).indexOf(-1) === -1;
  };

  Store.prototype.includes = function() {
    var mixedValues;
    mixedValues = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    return mixedValues.map((function(_this) {
      return function(mixedValue) {
        return _this.values.indexOf(mixedValue);
      };
    })(this)).indexOf(-1) === -1;
  };

  Store.prototype.keyOf = function(data) {
    var key, ref1, value;
    ref1 = this.data;
    for (key in ref1) {
      if (!hasProp.call(ref1, key)) continue;
      value = ref1[key];
      if (data === value) {
        return key;
      }
    }
  };

  Store.prototype.get = function(key) {
    if (this.has(key)) {
      return this.data[key];
    } else {
      return null;
    }
  };

  Store.prototype.set = function(key, data) {
    this.data[key] = data;
    return this;
  };

  Store.prototype.is = function(key, data) {
    var item;
    if (this.has(key)) {
      item = this.get(key);
      return item === data;
    }
    return false;
  };

  Store.prototype.grab = function(key) {
    var data;
    data = this.get(key);
    this.remove(key);
    return data;
  };

  Store.prototype.remove = function(key) {
    if (this.has(key)) {
      delete this.data[key];
    }
    return this;
  };

  Store.prototype.replace = function(dataStore) {
    if (dataStore == null) {
      dataStore = {};
    }
    this.data = dataStore;
    return this;
  };

  Store.prototype.merge = function(dataStore) {
    if (dataStore == null) {
      dataStore = {};
    }
    if (dataStore instanceof Storage) {
      dataStore = dataStore.data;
    }
    this.replace(extend(this.data, dataStore));
    return this;
  };

  Store.prototype.shuffle = function() {
    var _store, i, key, keys, len;
    keys = this.shuffledKeys;
    _store = {};
    for (i = 0, len = keys.length; i < len; i++) {
      key = keys[i];
      _store[key] = this.data[key];
    }
    this.replace(_store);
    return this;
  };

  Store.prototype.pop = function() {
    return this.grab(this.lastKey);
  };

  Store.prototype.shift = function() {
    return this.grab(this.firstKey);
  };

  Store.prototype.destroy = function() {
    this.data = {};
    return this;
  };

  Store.prototype.serialize = function() {
    return serialize(this.data);
  };

  Store.prototype.parameterize = function() {
    return parameterize(this.data);
  };

  return Store;

})(EventEmitter);

module.exports = Store;
