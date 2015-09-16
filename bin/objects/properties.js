var Properties, mutable;

mutable = require('../utils').mutable;

Properties = (function() {
  var _properties;

  function Properties() {}

  _properties = {};

  Properties.normalize = function(propertyDefaults, propertyDescriptions) {
    var propertyName, propertyValue;
    for (propertyName in propertyDefaults) {
      propertyValue = propertyDefaults[propertyName];
      if (propertyDescriptions.hasOwnProperty(propertyName)) {
        propertyDescriptions[propertyName]["default"] = propertyValue;
      }
    }
    return propertyDescriptions;
  };

  Properties.define = function(targetObject, propertyDescriptions) {
    var canDefineSetter, get, propertyDescription, propertyName, ref, ref1, set;
    ref = mutable(targetObject), get = ref.get, set = ref.set;
    for (propertyName in propertyDescriptions) {
      propertyDescription = propertyDescriptions[propertyName];
      get(propertyName, function() {
        var ref1;
        if (_properties[propertyName] != null) {
          return _properties[propertyName];
        }
        return (ref1 = propertyDescription["default"]) != null ? ref1 : null;
      });
      if (propertyDescription.readonly == null) {
        canDefineSetter = true;
        if ((propertyDescription.validates != null) && typeof propertyDescription.validates === 'function') {
          canDefineSetter = propertyDescription.validates.apply(targetObject, [(ref1 = propertyDescription["default"]) != null ? ref1 : null]);
        }
        if (canDefineSetter) {
          set(propertyName, function(propertyValue) {
            return _properties[propertyName] = propertyValue;
          });
        }
        return;
      }
    }
  };

  return Properties;

})();

module.exports = Properties;
