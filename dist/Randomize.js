var Randomize,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  slice = [].slice;

require('es5-shim');

require('es6-shim');

Randomize = (function() {
  var _pickFromArray, _pickFromObject;

  function Randomize() {
    this._weightedFromArray = bind(this._weightedFromArray, this);
  }

  Randomize.between = function(min, max) {
    var rndm;
    rndm = Math.random();
    return rndm * (max - min) + min;
  };

  _pickFromArray = function(list) {
    var rndm;
    rndm = Math.random();
    return list[list.length * rndm << 0];
  };

  _pickFromObject = function(list) {
    return list[_pickFromArray(Object.keys(list))];
  };

  Randomize.pick = function(list) {
    var isArray;
    isArray = Array.isArray(list);
    if (typeof list === 'object' && isArray === false) {
      return _pickFromObject(list);
    } else if (isArray === true) {
      return _pickFromArray(list);
    }
    return null;
  };

  Randomize.prototype._weightedFromArray = function() {
    var index, key, list, ref, rndm, totalWeight, val, weight, weightSum, weights;
    list = arguments[0], weights = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    index = 0;
    weight = [];
    weightSum = 0;
    for (key in list) {
      val = list[key];
      weight[key] = (ref = weights[key]) != null ? ref : .5;
    }
    totalWeight = weight.reduce(function(prev, current, index, list) {
      return prev + current;
    });
    rndm = this.between(0, totalWeight);
    while (index < list.length) {
      weightSum += weight[index];
      weightSum = +weightSum.toFixed(2);
      if (rndm <= weightSum) {
        return list[index];
      }
      index++;
    }
  };

  Randomize.prototype._weightedFromObject = function() {
    var list, weights;
    list = arguments[0], weights = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    return list[_weightedFromObject.apply(null, [Object.keys(list)].concat(slice.call(weights)))];
  };

  Randomize.weighted = function(list) {
    var isArray;
    isArray = Array.isArray(list);
    if (typeof list === 'object' && isArray === false) {
      return _weightedFromObject.apply(null, [list].concat(slice.call(weights)));
    } else if (isArray === true) {
      return _weightedFromArray.apply(null, [list].concat(slice.call(weights)));
    }
    return null;
  };

  return Randomize;

})();

module.exports = Randomize;
