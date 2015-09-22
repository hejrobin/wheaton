var Properties, extend, mutatorsFor, ref,
  hasProp = {}.hasOwnProperty;

ref = require('./Mutate'), extend = ref.extend, mutatorsFor = ref.mutatorsFor;

Properties = (function() {
  var _defineMutators;

  function Properties() {}

  Properties.PropTypes = {
    'any': function(property) {
      return true;
    },
    'bool': function(property) {
      return typeof property === 'boolean';
    },
    'array': function(property) {
      return Array.isArray(property);
    },
    'string': function(property) {
      return typeof property === 'string';
    },
    'number': function(property) {
      return typeof property === 'number';
    },
    'object': function(property) {
      return typeof property === 'object' && Array.isArray(property) === false;
    },
    'number': function(property) {
      return typeof property === 'number';
    }
  };

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
    ref1 = mutatorsFor(targetObject), get = ref1.get, set = ref1.set;
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

  return Properties;

})();

module.exports = Properties;
