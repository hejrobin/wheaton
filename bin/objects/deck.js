var Deck, Storage,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Storage = require('../data/storage');

Deck = (function(superClass) {
  extend(Deck, superClass);

  function Deck() {
    return Deck.__super__.constructor.apply(this, arguments);
  }

  Deck.prototype.draw = function(shuffleAfterDraw) {
    var cardObject, cardObjectKey;
    if (shuffleAfterDraw == null) {
      shuffleAfterDraw = false;
    }
    cardObjectKey = this.lastKey;
    cardObject = this.get(cardObjectKey);
    cardObject.draw();
    if (cardObject.quantity <= 0) {
      this.remove(cardObjectKey);
    }
    if (shuffleAfterDraw) {
      this.shuffle();
    }
    return cardObject;
  };

  return Deck;

})(Storage);

module.exports = Deck;
