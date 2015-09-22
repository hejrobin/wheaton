var Card, EventEmitter, Properties, extend,
  extend1 = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

EventEmitter = require('./EventEmitter');

Properties = require('./Properties');

extend = require('./Mutate').extend;

Card = (function(superClass) {
  var defaultProperties;

  extend1(Card, superClass);

  defaultProperties = {
    guid: {
      readonly: true,
      validates: Properties.PropTypes.string
    },
    name: {
      readonly: true,
      validates: Properties.PropTypes.string
    },
    drawn: {
      "default": false,
      validates: Properties.PropTypes.bool
    },
    played: {
      "default": false,
      validates: Properties.PropTypes.bool
    },
    palmed: {
      "default": false,
      validates: Properties.PropTypes.bool
    },
    discarded: {
      "default": false,
      validates: Properties.PropTypes.bool
    },
    deckLimit: {
      "default": 1,
      validates: Properties.PropTypes.number
    },
    quantity: {
      "default": 1,
      validates: Properties.PropTypes.number
    },
    description: {
      validates: Properties.PropTypes.string
    }
  };

  Card.prototype.instanceProperties = {};

  Card.prototype.defaultOptions = {};

  Card.prototype.instanceOptions = {};

  function Card(cardProperties) {
    var instanceOptions;
    if (cardProperties == null) {
      cardProperties = {};
    }
    instanceOptions = {};
    if (cardProperties.hasOwnProperty('instanceOptions')) {
      instanceOptions = cardProperties.instanceOptions;
      delete cardProperties.instanceOptions;
    }
    cardProperties = Properties.normalize(defaultProperties, cardProperties);
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

  Card.prototype.add = function() {
    if (!this.discarded) {
      this.emit('add', this);
      this.quantity++;
      if (this.quantity > this.deckLimit) {
        this.quantity = this.deckLimit;
      } else {
        this.emit('added', this);
      }
    }
    return this;
  };

  Card.prototype.draw = function() {
    if (!this.drawn) {
      this.emit('draw', this);
      this.drawn = true;
      this.quantity--;
      if (this.quantity < 0) {
        this.quantity = 0;
      }
      this.emit('drawn', this);
    }
    return this;
  };

  Card.prototype.play = function() {
    if (this.drawn && !this.played) {
      this.emit('play', this);
      this.played = true;
      this.emit('played', this);
    }
    return this;
  };

  Card.prototype.palm = function() {
    if (this.drawn && !this.palmed) {
      this.emit('palm', this);
      this.palmed = true;
      this.emit('palmed', this);
    }
    return this;
  };

  Card.prototype.revive = function() {
    if (this.drawn && this.discarded) {
      this.emit('revive', this);
      this.discarded = false;
      this.emit('revived', this);
    }
    return this;
  };

  Card.prototype.discard = function() {
    if (this.drawn && !this.discarded) {
      this.emit('discard', this);
      this.quantity = 0;
      this.discarded = true;
      this.emit('discarded', this);
    }
    return this;
  };

  return Card;

})(EventEmitter);

module.exports = Card;
