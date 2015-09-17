var Properties, extend, mutable, ref,
  hasProp = {}.hasOwnProperty;

ref = require('../utils'), mutable = ref.mutable, extend = ref.extend;

Properties = (function() {
  var _defineMutators;

  function Properties() {}

  Properties.normalize = function(propertyDefaults, propertyDescriptions) {
    var normalizedProperties, propertyName, propertyValue;
    normalizedProperties = extend({}, propertyDefaults);
    for (propertyName in propertyDefaults) {
      propertyValue = propertyDefaults[propertyName];
      if (propertyDescriptions.hasOwnProperty(propertyName)) {
        normalizedProperties[propertyName] = {
          validates: Properties.PropTypes.any,
          "default": propertyDescriptions[propertyName]
        };
      }
    }
    return normalizedProperties;
  };

  _defineMutators = function(targetObject, propertyName, propertyDescription) {
    var get, readonly, ref1, set;
    ref1 = mutable(targetObject), get = ref1.get, set = ref1.set;
    readonly = propertyDescription.hasOwnProperty('readonly');
    get(propertyName, function() {
      var propertyDefault, propertyValue;
      if ((targetObject.instanceProperties != null) && targetObject.instanceProperties.hasOwnProperty(propertyName)) {
        propertyValue = targetObject.instanceProperties[propertyName].value;
        propertyDefault = targetObject.instanceProperties[propertyName]["default"];
        return propertyValue != null ? propertyValue : propertyDefault;
      }
    });
    return set(propertyName, function(propertyValue) {
      if (readonly) {
        return;
      }
      if ((propertyDescription.validates != null) && typeof propertyDescription.validates === 'function') {
        targetObject.instanceProperties[propertyName].value = propertyValue;
      }
    });
  };

  Properties.define = function(targetObject, propertyDescriptions) {
    var propertyDescription, propertyName, ref1;
    targetObject.instanceProperties = propertyDescriptions;
    ref1 = targetObject.instanceProperties;
    for (propertyName in ref1) {
      if (!hasProp.call(ref1, propertyName)) continue;
      propertyDescription = ref1[propertyName];
      _defineMutators(targetObject, propertyName, propertyDescription);
    }
  };

  Properties.PropTypes = {
    'any': function(property) {
      return true;
    },
    'bool': function(property) {
      return typeof property === 'boolean';
    },
    'array': function(property) {
      return typeof property === 'array';
    },
    'string': function(property) {
      return typeof property === 'string';
    },
    'number': function(property) {
      return typeof property === 'number';
    },
    'object': function(property) {
      return typeof property === 'object';
    },
    'number': function(property) {
      return typeof property === 'number';
    }
  };

  return Properties;

})();

module.exports = Properties;
