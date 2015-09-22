var Deck, Store,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Store = require('./Store');

Deck = (function(superClass) {
  extend(Deck, superClass);

  function Deck() {
    return Deck.__super__.constructor.apply(this, arguments);
  }

  Deck.prototype.draw = function(drawRandom) {
    var cardObject, cardObjectKey;
    if (drawRandom == null) {
      drawRandom = false;
    }
    this.emit('draw', this);
    cardObjectKey = drawRandom === true ? this.randomKey : this.lastKey;
    cardObject = this.get(cardObjectKey);
    cardObject.draw();
    if (cardObject.quantity <= 0) {
      this.remove(cardObjectKey);
    }
    this.emit('drawn');
    return cardObject;
  };

  return Deck;

})(Store);

module.exports = Deck;
