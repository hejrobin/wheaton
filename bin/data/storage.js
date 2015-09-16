var Storage, extend, mutable, parameterize, serialize, utils,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  slice = [].slice;

utils = require('../utils');

extend = utils.extend, mutable = utils.mutable;

parameterize = utils.parameterize;

serialize = utils.serialize;

Storage = (function() {
  var _dataStore, get, ref, set;

  ref = mutable(Storage.prototype), get = ref.get, set = ref.set;

  _dataStore = {};

  function Storage(dataStore) {
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
    var keys, rndm;
    keys = this.keys;
    rndm = Math.random();
    return keys[keys.length * rndm << 0];
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

  Storage.prototype.has = function() {
    var keys;
    keys = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    return keys.map((function(_this) {
      return function(key) {
        return _this.keys.indexOf(key);
      };
    })(this)).indexOf(-1) === -1;
  };

  Storage.prototype.includes = function() {
    var mixedValues;
    mixedValues = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    return mixedValues.map((function(_this) {
      return function(mixedValue) {
        return _this.values.indexOf(mixedValue);
      };
    })(this)).indexOf(-1) === -1;
  };

  Storage.prototype.get = function(key) {
    if (this.has(key)) {
      return this.data[key];
    } else {
      return null;
    }
  };

  Storage.prototype.set = function(key, data) {
    this.data[key] = data;
    return this;
  };

  Storage.prototype.is = function(key, data) {
    var item;
    if (this.has(key)) {
      item = this.get(key);
      return item === data;
    }
    return false;
  };

  Storage.prototype.grab = function(key) {
    var data;
    data = this.get(key);
    this.remove(key);
    return data;
  };

  Storage.prototype.remove = function(key) {
    if (this.has(key)) {
      delete this.data[key];
    }
    return this;
  };

  Storage.prototype.replace = function(dataStore) {
    if (dataStore == null) {
      dataStore = {};
    }
    this.data = dataStore;
    return this;
  };

  Storage.prototype.merge = function(dataStore) {
    if (dataStore == null) {
      dataStore = {};
    }
    if (dataStore instanceof Storage) {
      dataStore = dataStore.data;
    }
    this.replace(extend(this.data, dataStore));
    return this;
  };

  Storage.prototype.shuffle = function() {
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

  Storage.prototype.pop = function() {
    return this.grab(this.lastKey);
  };

  Storage.prototype.shift = function() {
    return this.grab(this.firstKey);
  };

  Storage.prototype.destroy = function() {
    this.data = {};
    return this;
  };

  Storage.prototype.serialize = function() {
    return serialize(this.data);
  };

  Storage.prototype.parameterize = function() {
    return parameterize(this.data);
  };

  return Storage;

})();

module.exports = Storage;
