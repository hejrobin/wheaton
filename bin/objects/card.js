var Card, Emitter, Properties, extend,
  extend1 = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

Emitter = require('../event/emitter');

Properties = require('./properties');

extend = require('../utils').extend;

Card = (function(superClass) {
  var defaultProperties;

  extend1(Card, superClass);

  defaultProperties = {
    guid: {
      readonly: true,
      validates: function(property) {
        return typeof property === 'string';
      }
    },
    name: {
      readonly: true,
      validates: function(property) {
        return typeof property === 'string';
      }
    },
    drawn: {
      "default": false,
      validates: function(property) {
        return typeof property === 'boolean';
      }
    },
    played: {
      "default": false,
      validates: function(property) {
        return typeof property === 'boolean';
      }
    },
    palmed: {
      "default": false,
      validates: function(property) {
        return typeof property === 'boolean';
      }
    },
    discarded: {
      "default": false,
      validates: function(property) {
        return typeof property === 'boolean';
      }
    }
  };

  Card.prototype.defaultOptions = {
    onDraw: function() {},
    onPlay: function() {},
    onPalm: function() {},
    onRevive: function() {},
    onDiscard: function() {}
  };

  Card.prototype.instanceOptions = {};

  function Card(cardProperties) {
    var instanceOptions, ref;
    if (cardProperties == null) {
      cardProperties = {};
    }
    instanceOptions = (ref = cardProperties.instanceOptions) != null ? ref : {};
    delete cardProperties.instanceOptions;
    cardProperties = Properties.normalize(cardProperties, defaultProperties);
    Properties.define(this, cardProperties);
    this.options(this.defaultOptions).options(instanceOptions);
    return;
  }

  Card.prototype.options = function(newOptions) {
    if (newOptions == null) {
      newOptions = {};
    }
    this.instanceOptions = extend(this.instanceOptions, newOptions);
    return this;
  };

  Card.prototype.call = function() {
    var callable, callableArguments;
    callable = arguments[0], callableArguments = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    if (typeof callable === 'function') {
      callable.apply(this, callableArguments);
    }
    return this;
  };

  Card.prototype.draw = function() {
    if (!this.drawn) {
      this.drawn = true;
      this.call(this.instanceOptions.onDraw);
      this.emit('draw', this);
    }
    return this;
  };

  Card.prototype.play = function() {
    if (this.drawn && !this.played) {
      this.call(this.instanceOptions.onPlay);
      this.emit('play', this);
      this.played = true;
    }
    return this;
  };

  Card.prototype.palm = function() {
    if (this.drawn && !this.palmed) {
      this.call(this.instanceOptions.onPalm);
      this.emit('palm', this);
      this.palmed = true;
    }
    return this;
  };

  Card.prototype.revive = function() {
    if (this.drawn && this.discarded) {
      this.call(this.instanceOptions.onRevive);
      this.emit('revive', this);
      this.discarded = false;
    }
    return this;
  };

  Card.prototype.discard = function() {
    if (this.drawn && !this.discarded) {
      this.call(this.instanceOptions.onDiscard);
      this.emit('discard', this);
      this.discarded = true;
    }
    return this;
  };

  return Card;

})(Emitter);

module.exports = Card;
