var Mutate,
  slice = [].slice;

Mutate = (function() {
  function Mutate() {}

  Mutate.extend = function() {
    var i, key, len, mutableObjects, sourceObject, targetObject;
    targetObject = arguments[0], mutableObjects = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    for (i = 0, len = mutableObjects.length; i < len; i++) {
      sourceObject = mutableObjects[i];
      for (key in sourceObject) {
        if (sourceObject.hasOwnProperty(key)) {
          targetObject[key] = sourceObject[key];
        }
      }
    }
    return targetObject;
  };

  Mutate.serialize = function(sourceObject) {
    return JSON.stringify(sourceObject);
  };

  Mutate.parameterize = function(sourceObject, prefix) {
    var data, key, segments;
    if (prefix == null) {
      prefix = null;
    }
    segments = [];
    for (key in sourceObject) {
      data = sourceObject[key];
      if (prefix != null) {
        key = prefix + "[" + key + "]";
      }
      if (typeof data === 'object') {
        segments.push(Mutate.parameterize(data, key));
      } else {
        segments.push((encodeURIComponent(key)) + "=" + (encodeURIComponent(data)));
      }
    }
    return segments.join('&');
  };

  Mutate.mutatorsFor = function(prototypable) {
    return {
      get: function(propertyName, propertyCallback, propertyDescription) {
        if (propertyDescription == null) {
          propertyDescription = {};
        }
        propertyDescription = Mutate.extend({
          get: propertyCallback,
          configurable: true,
          enumerable: true
        }, propertyDescription);
        return Object.defineProperty(prototypable, propertyName, propertyDescription);
      },
      set: function(propertyName, propertyCallback, propertyDescription) {
        if (propertyDescription == null) {
          propertyDescription = {};
        }
        propertyDescription = Mutate.extend({
          set: propertyCallback,
          configurable: true,
          enumerable: true
        }, propertyDescription);
        return Object.defineProperty(prototypable, propertyName, propertyDescription);
      }
    };
  };

  return Mutate;

})();

module.exports = Mutate;
