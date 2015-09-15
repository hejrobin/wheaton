var Wheaton;

Wheaton = (function() {
  function Wheaton() {}

  Wheaton["import"] = function(wheatonPackage) {
    return require("./" + wheatonPackage);
  };

  return Wheaton;

})();

module.exports = Wheaton;
