var Storage, extend, mutable, parameterize, serialize, utils,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

utils = require('../utils');

extend = utils.extend, mutable = utils.mutable;

parameterize = utils.parameterize;

serialize = utils.serialize;

Storage = (function() {
  var _dataStore, get, ref, set;

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

  ref = mutable(Storage.prototype), get = ref.get, set = ref.set;

  get('store', function() {
    return _dataStore;
  });

  set('store', function(newStore) {
    if (newStore == null) {
      newStore = {};
    }
    return _dataStore = newStore;
  });

  get('length', function() {
    return Object.keys(this.store).length;
  });

  get('keys', function() {
    return Array.prototype.slice.apply(Object.keys(this.store));
  });

  get('values', function() {
    var dataStoreValues;
    dataStoreValues = Object.keys(_dataStore).map((function(_this) {
      return function(key) {
        return _this.store[key];
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
    return this.randomKeyFrom(this.store);
  });

  Storage.prototype.randomKeyFrom = function(object) {
    var keys, rndm;
    keys = Object.keys(object);
    rndm = Math.random();
    return keys[keys.length * rndm << 0];
  };

  Storage.prototype.has = function(key) {
    return key in this.store;
  };

  Storage.prototype.get = function(key) {
    if (this.has(key)) {
      return this.store[key];
    }
  };

  Storage.prototype.set = function(key, data) {
    this.store[key] = data;
    return this;
  };

  Storage.prototype.is = function(key, data) {
    var item;
    if (this.has(key)) {
      item = this.get(key);
      item === data;
    }
    return false;
  };

  Storage.prototype.remove = function(key) {
    if (this.has(key)) {
      return delete this.store[key];
    }
  };

  Storage.prototype.replace = function(dataStore) {
    if (dataStore == null) {
      dataStore = {};
    }
    return this.store = dataStore;
  };

  Storage.prototype.merge = function(newStorage) {
    var newCrate;
    if (newStorage == null) {
      newStorage = {};
    }
    if (newStorage.store != null) {
      newCrate = newStorage.store;
    }
    this.replace(extend(this.store, newStorage));
    return this;
  };

  Storage.prototype.destroy = function() {
    return this.store = {};
  };

  Storage.prototype.serialize = function() {
    return serialize(this.store);
  };

  Storage.prototype.parameterize = function() {
    return parameterize(this.store);
  };

  return Storage;

})();

module.exports = Storage;
