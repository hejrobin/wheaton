var Wheaton;

Wheaton = (function() {
  function Wheaton() {}

  Wheaton["import"] = function(wheatonPackage) {
    return require("./" + (wheatonPackage.toLowerCase()));
  };

  return Wheaton;

})();

module.exports = Wheaton;
