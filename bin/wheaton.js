var Wheaton, path;

path = require('path');

Wheaton = (function() {
  function Wheaton() {}

  Wheaton["import"] = function(wheatonPackage) {
    console.warn('Deprecation warning: Objects are exposed to Wheaton.');
    return require(path.join(__dirname, wheatonPackage));
  };

  return Wheaton;

})();

module.exports["import"] = Wheaton["import"];

module.exports.Storage = require('./data/storage');

module.exports.Deck = require('./objects/deck');

module.exports.Card = require('./objects/card');
