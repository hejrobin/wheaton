var CoffeeScript = require('coffee-script');

module.exports = {
  process: function(src, path) {
    if(CoffeeScript.helpers.isCoffee(path)) {
      return CoffeeScript.compile(src, {
        'bare': true
      });
    }
    return src;
  }
};
