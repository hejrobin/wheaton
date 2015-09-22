var EventEmitter,
  slice = [].slice;

EventEmitter = (function() {
  function EventEmitter() {}

  EventEmitter.prototype.defaultMaxListeners = 10;

  EventEmitter.prototype.maxListeners = null;

  EventEmitter.prototype.eventListeners = {};

  EventEmitter.prototype.setMaxListeners = function(maxListeners) {
    this.maxListeners = maxListeners;
    return this;
  };

  EventEmitter.prototype.getMaxListeners = function() {
    if (typeof this.maxListeners === 'number') {
      return this.maxListeners;
    } else {
      return this.defaultMaxListeners;
    }
  };

  EventEmitter.prototype.hasListeners = function(eventType) {
    return this.eventListeners.hasOwnProperty(eventType);
  };

  EventEmitter.prototype.listeners = function(eventType) {
    if (this.hasListeners(eventType)) {
      return this.eventListeners[eventType];
    } else {
      return [];
    }
  };

  EventEmitter.prototype.listenerCount = function(eventType) {
    return this.listeners(eventType).length;
  };

  EventEmitter.prototype.hasListener = function(eventType, eventCallback) {
    if (this.hasListeners(eventType)) {
      if (this.eventListeners[eventType].indexOf(eventCallback) > -1) {
        return true;
      }
    }
    return false;
  };

  EventEmitter.prototype.addListener = function(eventType, eventCallback) {
    if (!this.hasListeners(eventType)) {
      this.eventListeners[eventType] = [];
    }
    if (!(this.listenerCount(eventType) >= this.getMaxListeners())) {
      if (!this.hasListener(eventType, eventCallback)) {
        this.eventListeners[eventType].push(eventCallback);
      }
    }
    return this;
  };

  EventEmitter.prototype.addOnceListener = function(eventType, eventCallback) {
    var onceListener;
    onceListener = (function(_this) {
      return function() {
        _this.removeListener(eventType, onceListener);
        return eventCallback.call(arguments);
      };
    })(this);
    this.addListener(eventType, onceListener);
    return this;
  };

  EventEmitter.prototype.removeListener = function(eventType, eventCallback) {
    var listenerCallbackIndex;
    if (this.hasListeners(eventType)) {
      listenerCallbackIndex = this.listeners(eventType).indexOf(eventCallback);
      if (listenerCallbackIndex >= 0) {
        this.eventListeners[eventType].splice(listenerCallbackIndex, 1);
      }
    }
    return this;
  };

  EventEmitter.prototype.removeAllListeners = function() {
    var eventType, eventTypes, i, len;
    eventTypes = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    if (eventTypes.length === 0) {
      this.eventListeners = {};
      return this;
    }
    for (i = 0, len = eventTypes.length; i < len; i++) {
      eventType = eventTypes[i];
      if (this.hasListeners(eventType)) {
        delete this.eventListeners[eventType];
      }
    }
    return this;
  };

  EventEmitter.prototype.emit = function() {
    var callbackArguments, eventCallback, eventCallbacks, eventType, ref, results;
    eventType = arguments[0], callbackArguments = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    if (this.eventListeners.hasOwnProperty(eventType)) {
      ref = this.eventListeners;
      results = [];
      for (eventType in ref) {
        eventCallbacks = ref[eventType];
        results.push((function() {
          var i, len, results1;
          results1 = [];
          for (i = 0, len = eventCallbacks.length; i < len; i++) {
            eventCallback = eventCallbacks[i];
            results1.push(eventCallback.call(callbackArguments));
          }
          return results1;
        })());
      }
      return results;
    }
  };

  EventEmitter.prototype.on = function() {
    return this.addListener.apply(this, arguments);
  };

  EventEmitter.prototype.once = function() {
    return this.addOnceListener.apply(this, arguments);
  };

  EventEmitter.prototype.off = function() {
    return this.removeListener.apply(this, arguments);
  };

  return EventEmitter;

})();

module.exports = EventEmitter;
